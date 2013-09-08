//
//  ORMapView_Private.h
//  ORMapView Example
//
//  Created by Philipp Schmid on 9/8/13.
//  Copyright (c) 2013 Philipp Schmid. All rights reserved.
//

#import "ORMapView.h"

#import "ORClusterAnnotation_Private.h"
#import "ADMapCluster.h"

@interface ORMapView () <MKMapViewDelegate> {
    NSMutableArray* _userAnnotations;
    
    ADMapCluster *  _rootMapCluster;
    
    BOOL _reclusteringInProcess;
    BOOL _reclusterAfterCurrentClusteringFinished;
}

@property(nonatomic, assign) id<MKMapViewDelegate> realDelegate;


#pragma mark - MKMapViewDelegate Intercepts

- (void)_or_mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;
- (MKAnnotationView *)_or_mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation;

@end
