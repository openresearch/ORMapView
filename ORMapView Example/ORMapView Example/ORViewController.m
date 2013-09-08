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
#define ANNOTATIONS_STEP_VALUE 100
#define ANNOTATIONS_MAXIMUM_COUNT 1000000

@interface ORViewController ()
@end

@implementation ORViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Setup annotation stepper
    self.annotationsCountStepper.minimumValue = 0;
    self.annotationsCountStepper.maximumValue = ANNOTATIONS_MAXIMUM_COUNT;
    self.annotationsCountStepper.value = ANNOTATIONS_INITIAL_COUNT;
    self.annotationsCountStepper.stepValue = ANNOTATIONS_STEP_VALUE;
	
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
        NSMutableArray* annotations = [NSMutableArray arrayWithCapacity:ANNOTATIONS_STEP_VALUE];
        
        for(int i=0; i<ANNOTATIONS_STEP_VALUE; i++) {
            ORRandomAnnotation* randomAnnotation = [[ORRandomAnnotation alloc] init];
            [annotations addObject:randomAnnotation];
        }
        [self.mapView addAnnotations:annotations];
        
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

@end
