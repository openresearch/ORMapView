//
//  ORClusterAnnotation.m
//  ORMapView Example
//
//  Created by Philipp Schmid on 9/8/13.
//  Copyright (c) 2013 Philipp Schmid. All rights reserved.
//

#import "ORClusterAnnotation_Private.h"

@implementation ORClusterAnnotation

- (CLLocationCoordinate2D)coordinate
{
    if(self.adMapCluster) {
        return self.adMapCluster.clusterCoordinate;
    } else {
        return kCLLocationCoordinate2DInvalid;
    }
}

- (NSString*)title
{
    return [NSString stringWithFormat:@"%f %f", self.coordinate.latitude, self.coordinate.longitude];
}

- (NSUInteger)count
{
    if(self.adMapCluster) {
        return self.adMapCluster.numberOfChildren;
    } else {
        return 0;
    }
}

- (NSArray*)annotations
{
    if(self.adMapCluster) {
        return self.adMapCluster.originalAnnotations;
    } else {
        return [NSArray array];
    }
}

- (MKMapRect)encompassingMapRect
{
    if(self.adMapCluster) {
        return [self.adMapCluster encompassingMapRect];
    } else {
        return MKMapRectNull;
    }
}

@end
