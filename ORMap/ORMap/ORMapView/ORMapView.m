//
//  ORMapView.m
//  
//
//  Created by Philipp Schmid on 9/8/13.
//
//

#import "ORMapView_Private.h"

#import "NSObject+ORDebounce.h"


@implementation ORMapView

#pragma mark - Initialization & Destruction

- (void)_commonInit
{
    _clusteringEnabled = YES;
    _maximumNumberOfClusters = 32;
    _clusterDiscriminationPower = 1.0;
    
    _defaultClusterViewClass = [ORClusterAnnotationView class];
    
    _userAnnotations = [NSMutableArray array];
    
    [super setDelegate:self];
    
    [self addObserver:self forKeyPath:@"clusteringEnabled" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    [self addObserver:self forKeyPath:@"maximumNumberOfClusters" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    [self addObserver:self forKeyPath:@"clusterDiscriminationPower" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self _commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _commonInit];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"clusteringEnabled"];
    [self removeObserver:self forKeyPath:@"maximumNumberOfClusters"];
    [self removeObserver:self forKeyPath:@"clusterDiscriminationPower"];
    
    self.realDelegate = nil;
    [super setDelegate:nil];
}


#pragma mark - Accessing the Delegate

- (void)setDelegate:(id<MKMapViewDelegate>)delegate
{
    self.realDelegate = delegate;
    [super setDelegate:self];
}

- (id<MKMapViewDelegate>)delegate
{
    return self.realDelegate;
}


#pragma mark - Annotating the Map

- (NSArray*)displayedAnnotations
{
    return [super annotations];
}

- (NSArray*)annotations
{
    return [_userAnnotations copy];
}

- (void)addAnnotation:(id < MKAnnotation >)annotation
{
    [_userAnnotations addObject:annotation];
    
    if(self.clusteringEnabled) {
        [self _reclusterOnce];
    } else {
        [super addAnnotation:annotation];
    }
}

- (void)addAnnotations:(NSArray *)annotations
{
    [_userAnnotations addObjectsFromArray:annotations];
    
    if(self.clusteringEnabled) {
        [self _reclusterOnce];
    } else {
        [super addAnnotations:annotations];
    }
}

- (void)removeAnnotation:(id < MKAnnotation >)annotation
{
    [_userAnnotations removeObject:annotation];
    
    if(self.clusteringEnabled) {
        [self _reclusterOnce];
    } else {
        [super removeAnnotation:annotation];
    }
}

- (void)removeAnnotations:(NSArray *)annotations
{
    [_userAnnotations removeObjectsInArray:annotations];
    
    if(self.clusteringEnabled) {
        [self _reclusterOnce];
    } else {
        [super removeAnnotations:annotations];
    }
}




#pragma mark - Private

- (void)_clusteringEnabledChanged
{
    [self _removeAllAnnotationsFromMapViewExcludingUserLocation];
    
    if(self.clusteringEnabled) {
        [self _reclusterOnce];
    } else {
        [super addAnnotations:_userAnnotations];
    }
}

- (void)_maximumNumberOfClustersChanged
{
    if(self.clusteringEnabled) {
        [self _reclusterOnce];
    }
}

- (void)_clusterDiscriminationPowerChanged
{    
    if(self.clusteringEnabled) {
        [self _reclusterOnce];
    }
}

- (NSArray*)_displayedAnnotationsExcludingUserLocation
{
    NSPredicate * predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary * bindings) {
        return ![evaluatedObject isKindOfClass: [MKUserLocation class]];
    }];
    
    return [[super annotations] filteredArrayUsingPredicate:predicate];
}


- (void)_removeAllAnnotationsFromMapViewExcludingUserLocation
{
    [super removeAnnotations:[self _displayedAnnotationsExcludingUserLocation]];
}

- (NSArray*)_userAnnotationsExcludingSkipAnnotations
{
    if(self.skipAnnotations && self.skipAnnotations.count > 0) {
        NSMutableArray* _userAnnotationsExcludingSkipAnnotations = [NSMutableArray arrayWithArray:_userAnnotations];
        [_userAnnotationsExcludingSkipAnnotations removeObjectsInArray:self.skipAnnotations];
    
        return _userAnnotationsExcludingSkipAnnotations;
    } else {
        return _userAnnotations;
    }
}



#pragma mark - Private Clustering

/* Wrapper method for _recluster that reclusters only once per run-loop run */
- (void)_reclusterOnce
{
    [self performSelectorOnMainThreadOnce:@selector(__recluster)];
}

/* This method should only be called by _reclusterOnce so clustering happens
 * only once per run-loop run.
 */
- (void)__recluster
{
    if(_reclusteringInProcess) {
        _reclusterAfterCurrentClusteringFinished = YES;
        return;
    }
    
    _reclusteringInProcess = YES;
    
    NSArray* _cachedUserAnnotations = [[self _userAnnotationsExcludingSkipAnnotations] copy];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSMutableArray * mapPointAnnotations = [[NSMutableArray alloc] initWithCapacity:_cachedUserAnnotations.count];
        for (id<MKAnnotation> annotation in _cachedUserAnnotations) {
            ADMapPointAnnotation * mapPointAnnotation = [[ADMapPointAnnotation alloc] initWithAnnotation:annotation];
            [mapPointAnnotations addObject:mapPointAnnotation];
        }
        
        _rootMapCluster = [ADMapCluster rootClusterForAnnotations:mapPointAnnotations gamma:self.clusterDiscriminationPower clusterTitle:@"%d" showSubtitle:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _clusterInMapRect:self.visibleMapRect];
            
            _reclusteringInProcess = NO;
            
            if(_reclusterAfterCurrentClusteringFinished) {
                _reclusterAfterCurrentClusteringFinished = NO;
                
                [self _reclusterOnce];
            }
        });
    });

}

- (void)_clusterInMapRect:(MKMapRect)rect
{
    if(!self.clusteringEnabled) {
        return;
    }
    
    NSArray * clusters = [_rootMapCluster find:self.maximumNumberOfClusters childrenInMapRect:rect];
        
    NSMutableArray* singleAnnotationsToShow = [NSMutableArray array];
    NSMutableArray* clusterAnnotationsToShow = [NSMutableArray array];
    
    for (ADMapCluster * cluster in clusters) { // is the current annotation cluster an ancestor of one of the clustersToShowOnMap?
        if (cluster.annotation) {
            [singleAnnotationsToShow addObject:cluster.annotation.annotation];
        } else {
            
            ORClusterAnnotation* clusterAnnotation = [[ORClusterAnnotation alloc] init];
            clusterAnnotation.adMapCluster = cluster;
            
            [clusterAnnotationsToShow addObject:clusterAnnotation];
        }
    }
    
    
    NSMutableArray* annotationsToRemove = [NSMutableArray array];

    NSArray* currentAnnotations = [self _displayedAnnotationsExcludingUserLocation];
    for(id<MKAnnotation> annotation in currentAnnotations) {
        if([annotation isKindOfClass:[ORClusterAnnotation class]]) {
            [annotationsToRemove addObject:annotation];
            
        } else {
            if([singleAnnotationsToShow containsObject:annotation]) {
                [singleAnnotationsToShow removeObject:annotation];
            } else {
                [annotationsToRemove addObject:annotation];
            }
        }
    }
    
    [super removeAnnotations:annotationsToRemove];
    [super addAnnotations:singleAnnotationsToShow];
    [super addAnnotations:clusterAnnotationsToShow];
}



#pragma mark - MKMapViewDelegate Intercepts

/* We keep all the delegate proxy methods in a seperate category called DelegateProxy
 * The methods below are called from the DelegateProxy category
 */

- (void)_or_mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(self.clusteringEnabled) {
        [self _clusterInMapRect:self.visibleMapRect];
    }
}

- (MKAnnotationView *)_or_mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if([annotation isKindOfClass:[ORClusterAnnotation class]]) {
        NSString* reuseIdentifier = NSStringFromClass(self.defaultClusterViewClass);
        
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        if (!annotationView) {
            annotationView = [[self.defaultClusterViewClass alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        } else {
            [annotationView setAnnotation:annotation];
        }
        return annotationView;
    }
    
    return nil;
}




#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqual:@"clusteringEnabled"]) {
        NSObject* new = [change objectForKey:NSKeyValueChangeNewKey];
        NSObject* old = [change objectForKey:NSKeyValueChangeOldKey];
        
        if(![new isEqual:old]) {
            [self _clusteringEnabledChanged];
        }
    }
    
    else if ([keyPath isEqual:@"maximumNumberOfClusters"]) {
        NSObject* new = [change objectForKey:NSKeyValueChangeNewKey];
        NSObject* old = [change objectForKey:NSKeyValueChangeOldKey];
        
        if(![new isEqual:old]) {
            [self _maximumNumberOfClustersChanged];
        }
    }
    
    else if ([keyPath isEqual:@"clusterDiscriminationPower"]) {
        NSObject* new = [change objectForKey:NSKeyValueChangeNewKey];
        NSObject* old = [change objectForKey:NSKeyValueChangeOldKey];
        
        if(![new isEqual:old]) {
            [self _clusterDiscriminationPowerChanged];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
