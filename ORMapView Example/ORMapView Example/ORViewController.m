//
//  ORViewController.m
//  ORMapView Example
//
//  Created by Philipp Schmid on 9/6/13.
//  Copyright (c) 2013 Philipp Schmid. All rights reserved.
//

#import "ORViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "ORRandomAnnotation.h"

#define ANNOTATIONS_INITIAL_COUNT 1000
#define ANNOTATIONS_STEP_VALUE 1000
#define ANNOTATIONS_MAXIMUM_COUNT 10000000

@interface ORViewController ()
@end

@implementation ORViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    // Example on how to use a custom cluster view class with one line
//    // as an alternative to returing a view in mapView:viewForAnnotation:
//    // as shown below.
//    // Clusters have a red pin.
//    self.mapView.defaultClusterViewClass = [MKPinAnnotationView class];
    
    // Setup annotation stepper
    self.annotationsCountStepper.minimumValue = 0;
    self.annotationsCountStepper.maximumValue = ANNOTATIONS_MAXIMUM_COUNT;
    self.annotationsCountStepper.value = ANNOTATIONS_INITIAL_COUNT;
    self.annotationsCountStepper.stepValue = ANNOTATIONS_STEP_VALUE;
    
    // Setup cluster switch
    self.clusterSwitch.on = self.mapView.clusteringEnabled;
	
    // Generate initial annotations
    NSMutableArray* annotations = [NSMutableArray arrayWithCapacity:ANNOTATIONS_INITIAL_COUNT];
    for(int i=0; i<ANNOTATIONS_INITIAL_COUNT; i++) {
        ORRandomAnnotation* randomAnnotation = [[ORRandomAnnotation alloc] init];
        [annotations addObject:randomAnnotation];
    }
    [self.mapView addAnnotations:annotations];
    
}

- (IBAction)annotationsCountStepperValueChanged
{
    
    
    if(self.annotationsCountStepper.value > self.mapView.annotations.count) {
        for(int i=0; i<ANNOTATIONS_STEP_VALUE; i++) {
            ORRandomAnnotation* randomAnnotation = [[ORRandomAnnotation alloc] init];
            [self.mapView addAnnotation:randomAnnotation];
        }
        
    } else {
        NSMutableArray* annotations = [NSMutableArray arrayWithCapacity:ANNOTATIONS_STEP_VALUE];
        int i = 0;
        
        for(id<MKAnnotation> annotation in self.mapView.annotations) {
            if(i >= ANNOTATIONS_STEP_VALUE) {
                break;
            }
            
            if([annotation isKindOfClass:[ORRandomAnnotation class]]) {
                [annotations addObject:annotation];
                i+=1;
            }
        }
        
        [self.mapView removeAnnotations:annotations];
    }
}

- (IBAction)clusterSwitchChanged
{
    self.mapView.clusteringEnabled = self.clusterSwitch.on;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[ORRandomAnnotation class]]) {
        MKPinAnnotationView * pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ORRandomAnnotation"];
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ORRandomAnnotation"];
            pinView.pinColor = MKPinAnnotationColorPurple;
        }
        else {
            pinView.annotation = annotation;
        }
        return pinView;
    
    }
    
//    // Example of how to override default cluster view:
//    if([annotation isKindOfClass:[ORClusterAnnotation class]]) {
//        MKPinAnnotationView * clusterView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ORClusterAnnotation"];
//        if (!clusterView) {
//            clusterView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ORClusterAnnotation"];
//            clusterView.pinColor = MKPinAnnotationColorGreen;
//        }
//        else {
//            clusterView.annotation = annotation;
//        }
//        return clusterView;
//    }
    
    return nil;
}


- (void)mapView:(MKMapView *)aMapView didSelectAnnotationView:(MKAnnotationView *)view {
    id<MKAnnotation> annotation = view.annotation;
    
    if([annotation isKindOfClass:[ORClusterAnnotation class]]) {
        ORClusterAnnotation *clusterAnnotation = (ORClusterAnnotation*)annotation;
        MKCoordinateRegion region = MKCoordinateRegionForMapRect(clusterAnnotation.encompassingMapRect);
        [aMapView setRegion:[aMapView regionThatFits:region] animated:YES];
    }
}

@end
