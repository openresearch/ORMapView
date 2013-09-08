//
//  ORViewController.h
//  ORMapView Example
//
//  Created by Philipp Schmid on 9/6/13.
//  Copyright (c) 2013 Philipp Schmid. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ORMapView.h"

@interface ORViewController : UIViewController <MKMapViewDelegate>

@property(strong) IBOutlet ORMapView* mapView;
@property(strong) IBOutlet UIStepper* annotationsCountStepper;

@end
