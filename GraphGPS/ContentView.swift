import SwiftUI
import MapKit

struct ContentView: View {
    @State private var startAddress: String = ""
    @State private var endAddress: String = ""
    @State private var selectedAlgorithm = "BFS"
    @State private var pathSpeed: Double = 1.0
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var startLocation: CLLocationCoordinate2D?
    @State private var endLocation: CLLocationCoordinate2D?
    @State private var mapView = MKMapView()
    
    let algorithms = ["BFS", "DFS", "Dijkstra", "Bellman-Ford", "A*"]
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    TextField("Start Address", text: $startAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: {
                        geocodeAddress(startAddress) { coordinate in
                            if let coordinate = coordinate {
                                self.startLocation = coordinate
                                updateMapAnnotations()
                            }
                        }
                    }) {
                        Text("Set Start")
                    }
                    .padding()
                }
                HStack {
                    TextField("End Address", text: $endAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: {
                        geocodeAddress(endAddress) { coordinate in
                            if let coordinate = coordinate {
                                self.endLocation = coordinate
                                updateMapAnnotations()
                            }
                        }
                    }) {
                        Text("Set End")
                    }
                    .padding()
                }
            }
            MapViewWrapper(mapView: $mapView, region: $region, startLocation: $startLocation, endLocation: $endLocation)
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                Text("Algorithm:")
                Picker("Algorithm", selection: $selectedAlgorithm) {
                    ForEach(algorithms, id: \.self) { algo in
                        Text(algo).tag(algo)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            HStack {
                Text("Speed:")
                Slider(value: $pathSpeed, in: 0.1...5.0, step: 0.1)
                Text("\(pathSpeed, specifier: "%.1f")x")
            }
            .padding()
            
            Button(action: startPathfinding) {
                Text("Start Pathfinding")
            }
            .padding()
        }
    }
    
    func geocodeAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate)
            } else {
                completion(nil)
            }
        }
    }
    
    func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        if let start = startLocation {
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = start
            startAnnotation.title = "Start"
            mapView.addAnnotation(startAnnotation)
        }
        if let end = endLocation {
            let endAnnotation = MKPointAnnotation()
            endAnnotation.coordinate = end
            endAnnotation.title = "End"
            mapView.addAnnotation(endAnnotation)
        }
    }
    
    func startPathfinding() {
        guard let start = startLocation, let end = endLocation else { return }
        
        let path: [CLLocationCoordinate2D]?
        switch selectedAlgorithm {
        case "BFS":
            path = bfs(start: start, end: end)
        case "DFS":
            path = dfs(start: start, end: end)
        case "Dijkstra":
            path = dijkstra(start: start, end: end)
        case "Bellman-Ford":
            path = bellmanFord(start: start, end: end)
        case "A*":
            path = aStar(start: start, end: end)
        default:
            path = nil
        }
        
        if let path = path {
            visualizePathfinding(path: path, speed: pathSpeed, mapView: mapView)
        }
    }
    
    func visualizePathfinding(path: [CLLocationCoordinate2D], speed: Double, mapView: MKMapView) {
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 1.0 / speed, repeats: true) { timer in
            if index < path.count {
                let currentSegment = path[index]
                let polyline = MKPolyline(coordinates: [path[index], path[index == path.count - 1 ? index : index + 1]], count: 2)
                mapView.addOverlay(polyline)
                index += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct MapViewWrapper: UIViewRepresentable {
    @Binding var mapView: MKMapView
    @Binding var region: MKCoordinateRegion
    @Binding var startLocation: CLLocationCoordinate2D?
    @Binding var endLocation: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        if let start = startLocation {
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = start
            startAnnotation.title = "Start"
            uiView.addAnnotation(startAnnotation)
        }
        if let end = endLocation {
            let endAnnotation = MKPointAnnotation()
            endAnnotation.coordinate = end
            endAnnotation.title = "End"
            uiView.addAnnotation(endAnnotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewWrapper
        
        init(_ parent: MapViewWrapper) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 2.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
