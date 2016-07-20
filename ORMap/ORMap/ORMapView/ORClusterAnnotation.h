//
//  ORClusterAnnotation.h
//  ORMapView Example
//
//  Created by Philipp Schmid on 9/8/13.
//  Copyright (c) 2013 Philipp Schmid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ORClusterAnnotation : NSObject <MKAnnotation>

/** The number of annotations this cluster represents */
@property(readonly)NSUInteger count;

/** All annotatiosn this cluster represents */
@property(nonatomic,readonly) NSArray* annotations;

/** The MKMapRect that contains all annotations this cluster represents */
@property(nonatomic,readonly) MKMapRect encompassingMapRect;


@end
