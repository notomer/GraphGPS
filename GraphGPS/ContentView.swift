//
//  ContentView.swift
//  GraphGPS
//
//  Created by Omer Khan on 5/14/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var startLocation: CLLocationCoordinate2D?
    @State private var endLocation: CLLocationCoordinate2D?
    @State private var selectedAlgorithm = "BFS"
    @State private var pathSpeed: Double = 1.0
    
    let algorithms = ["BFS", "DFS", "Dijkstra", "Bellman-Ford", "A*"]
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [startLocation, endLocation].compactMap { $0 }) { location in
                MapPin(coordinate: location)
            }
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
    
    func startPathfinding() {
        // Implement the pathfinding logic here
    }
}
