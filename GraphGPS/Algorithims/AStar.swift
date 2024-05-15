import Foundation
import CoreLocation

func aStar(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> [CLLocationCoordinate2D]? {
    var openSet: Set<CLLocationCoordinate2D> = [start]
    var cameFrom: [CLLocationCoordinate2D: CLLocationCoordinate2D] = [:]
    
    var gScore: [CLLocationCoordinate2D: Double] = [start: 0]
    var fScore: [CLLocationCoordinate2D: Double] = [start: heuristic(from: start, to: end)]
    
    while !openSet.isEmpty {
        let current = openSet.min { fScore[$0, default: Double.infinity] < fScore[$1, default: Double.infinity] }!
        
        if current == end {
            return reconstructPath(cameFrom: cameFrom, start: start, end: end)
        }
        
        openSet.remove(current)
        
        for neighbor in neighbors(of: current) {
            let tentativeGScore = gScore[current, default: Double.infinity] + distance(from: current, to: neighbor)
            
            if tentativeGScore < gScore[neighbor, default: Double.infinity] {
                cameFrom[neighbor] = current
                gScore[neighbor] = tentativeGScore
                fScore[neighbor] = gScore[neighbor]! + heuristic(from: neighbor, to: end)
                openSet.insert(neighbor)
            }
        }
    }
    
    return nil
}
