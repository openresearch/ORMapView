//
//  ORMapView_DelegateProxy.m
//  ORMapView Example
//
//  Created by Philipp Schmid on 9/8/13.
//  Copyright (c) 2013 Philipp Schmid. All rights reserved.
//

#import "ORMapView_Private.h"

@implementation ORMapView (DelegateProxy)

#pragma mark - MKMapViewDelegate

// TODO: replace this proxy code with a class that forwards invocations automatically to the first
// delegate in the chain that responds to a selector


#pragma mark Responding to Map Position Changes

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:regionWillChangeAnimated:)]) {
        [self.realDelegate mapView:mapView regionWillChangeAnimated:animated];
    }
}

/** This method is not just a proxy */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self _or_mapView:mapView regionDidChangeAnimated:animated];
    
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:regionDidChangeAnimated:)]) {
        [self.realDelegate mapView:mapView regionDidChangeAnimated:animated];
    }
}

#pragma mark Loading the Map Data
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapViewWillStartLoadingMap:)]) {
        [self.realDelegate mapViewWillStartLoadingMap:mapView];
    }
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapViewDidFinishLoadingMap:)]) {
        [self.realDelegate mapViewDidFinishLoadingMap:mapView];
    }
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapViewDidFailLoadingMap:withError:)]) {
        [self.realDelegate mapViewDidFailLoadingMap:mapView withError:error];
    }
}


#pragma mark Tracking the User Location

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapViewWillStartLocatingUser:)]) {
        [self.realDelegate mapViewWillStartLocatingUser:mapView];
    }
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapViewDidStopLocatingUser:)]) {
        [self.realDelegate mapViewDidStopLocatingUser:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:didUpdateUserLocation:)]) {
        [self.realDelegate mapView:mapView didUpdateUserLocation:userLocation];
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:didFailToLocateUserWithError:)]) {
        [self.realDelegate mapView:mapView didFailToLocateUserWithError:error];
    }
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:didChangeUserTrackingMode:animated:)]) {
        [self.realDelegate mapView:mapView didChangeUserTrackingMode:mode animated:animated];
    }
}

#pragma mark Managing Annotation Views

/** This method is not just a proxy */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    MKAnnotationView* resultFromDelegate = nil;
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:viewForAnnotation:)]) {
        resultFromDelegate = [self.realDelegate mapView:mapView viewForAnnotation:annotation];
    }
    
    if(resultFromDelegate) {
        return resultFromDelegate;
        
    } else {
        return [self _or_mapView:mapView viewForAnnotation:annotation];
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:didAddAnnotationViews:)]) {
        [self.realDelegate mapView:mapView didAddAnnotationViews:views];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
        [self.realDelegate mapView:mapView annotationView:view calloutAccessoryControlTapped:control];
    }
}

#pragma mark Dragging an Annotation View

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:annotationView:didChangeDragState:fromOldState:)]) {
        [self.realDelegate mapView:mapView annotationView:annotationView didChangeDragState:newState fromOldState:oldState];
    }
}


#pragma mark Selecting Annotation Views
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:didSelectAnnotationView:)]) {
        [self.realDelegate mapView:mapView didSelectAnnotationView:view];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:didDeselectAnnotationView:)]) {
        [self.realDelegate mapView:mapView didDeselectAnnotationView:view];
    }
}


#pragma mark Managing Overlay Views

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:rendererForOverlay:)]) {
        return [self.realDelegate mapView:mapView rendererForOverlay:overlay];
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray<MKOverlayRenderer *> *)renderers
{
    if (self.realDelegate && [self.realDelegate respondsToSelector:@selector(mapView:didAddOverlayRenderers:)]) {
        [self.realDelegate mapView:mapView didAddOverlayRenderers:renderers];
    }
}


@end
