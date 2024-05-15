import Foundation
import CoreLocation
import MapKit

func visualizePathfinding(path: [CLLocationCoordinate2D], speed: Double, mapView: MKMapView) {
    var index = 0
    Timer.scheduledTimer(withTimeInterval: 1.0 / speed, repeats: true) { timer in
        if index < path.count {
            let currentSegment = path[index]
            // Update the map with the current path segment
            let polyline = MKPolyline(coordinates: path, count: path.count)
            mapView.addOverlay(polyline)
            index += 1
        } else {
            timer.invalidate()
        }
    }
}
