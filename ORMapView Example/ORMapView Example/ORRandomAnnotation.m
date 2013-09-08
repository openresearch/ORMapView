//
//  ORRandomAnnotation.m
//  ORMapView Example
//
//  Created by Philipp Schmid on 9/8/13.
//  Copyright (c) 2013 Philipp Schmid. All rights reserved.
//

#import "ORRandomAnnotation.h"

@interface ORRandomAnnotation () {
    CLLocationCoordinate2D _coordinate;
}
@end

@implementation ORRandomAnnotation

- (id)init
{
    self = [super init];
    if (self) {
        _coordinate = [self _randomCoordinate];
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    [self willChangeValueForKey:@"coordinate"];
    _coordinate = newCoordinate;
    [self didChangeValueForKey:@"coordinate"];
}

- (NSString*)title
{
    return [NSString stringWithFormat:@"%f %f", _coordinate.latitude, _coordinate.longitude];
}


- (CLLocationCoordinate2D)_randomCoordinate
{
    double xOffset = ((double)arc4random() / 0x100000000);
    double yOffset = ((double)arc4random() / 0x100000000);
    MKMapPoint randomPoint;
    
    randomPoint.x = MKMapRectWorld.origin.x + xOffset * MKMapRectWorld.size.width;
    randomPoint.y = MKMapRectWorld.origin.y + yOffset * MKMapRectWorld.size.height;
    
    return MKCoordinateForMapPoint(randomPoint);
}

@end
