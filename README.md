# ORMapView - MKMapView with clustering

`ORMapView` is a drop-in subclass of `MKMapView` that displays clusters of annotations. This is very useful in cases where you have to display many annotations on the map.

`ORMapView` is actually a fork of [ADClusterMapView][]

[ADClusterMapView]: [https://github.com/applidium/ADClusterMapView]

I liked their cluster implementation, but didn't need the complex animation code. I also wanted `ORMapView` to be a true drop-in replacement of `MKMapView` that does not wrap annotations in it's own `MKAnnotation` implementation, forcing you to modify your existing `MKMapViewDelegate` code.

The cluster algorithm and code itself (the hard part) is a plain copy from `ADClusterMapView`.
The algorithm concept is described on Applidium's [website][].

[website]: http://applidium.com/en/news/too_many_pins_on_your_map/

Differences to `ADClusterMapView` are:

1. Does not warp your annotations in a custom `MKAnnotation` implementation which would force you to rewrite your `MKMapViewDelegate` delegate methods which have an `MKAnnotation` as a parameter.
2. Allows you to enable and disable clustering anytime by just setting the `clusteringEnabled` property.
3. Does not support animations.
4. Provides a default cluster annotation view.
5. `ADClusterMapView` classes convert to ARC.

## Quick start

1. Add the content of the `ORMapView` folder to your iOS project.
2. Link against the MapKit and CoreLocation frameworks if you don't already.
3. Turn your `MKMapView` instance into an `ORMapView` instance.
4. Look at the example project on how to use a custom `MKAnnotationView` subclass for displaying a `ORClusterAnnotation` on the map.

