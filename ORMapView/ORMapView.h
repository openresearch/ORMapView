//
//  ORMapView.h
//  
//
//  Created by Philipp Schmid on 9/8/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "ORClusterAnnotation.h"
#import "ORClusterAnnotationView.h"

@interface ORMapView : MKMapView

#pragma mark - Clustering Settings

/** Enables clustering. If disabled, ORMapView behaves mostly like it's super class MKMapView 
  * Enabled by default.
  */
@property(assign) BOOL clusteringEnabled;

/** Setting the maximum number of clusters that you want to display at the same time
  * Default is 32.
  */
@property(assign) NSUInteger maximumNumberOfClusters;

/** Disminish outliers weight
  *  This parameter emphasizes the discrimination of annotations which are far away from the center of mass.
  *  default: 1.0 (no discrimination applied)
  */
@property(assign) double clusterDiscriminationPower;




#pragma mark - Annotating the Map

/** Annotations included in this array won't be clustered */
@property(nonatomic,strong) NSArray *skipAnnotations;

/** Annotations that are added to MKMapView, that is all
  * annotations currently not clustered as well as ORCluster
  * instances and MKUserLocation if showsUserLocation is enabled
  *
  * This property is the closest thing to the original annotations property.
  * If clustering is disabled, this property behaves the same as the annotations
  * property.
  */
@property(nonatomic,readonly) NSArray *displayedAnnotations;


/** This property returns all annotations added to the map view
  * It behaves a little bit different as the original MKMapView property
  * as it only returns annotations added by addAnnotation: or addAnnotations:
  * and does not include the MKUserLocation annotation.
  * Be carefull as this behavior might change.
  */
@property(nonatomic, readonly) NSArray *annotations;


@end
