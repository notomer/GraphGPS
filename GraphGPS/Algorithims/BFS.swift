import Foundation
import CoreLocation

func bfs(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> [CLLocationCoordinate2D]? {
    var queue: [CLLocationCoordinate2D] = [start]
    var visited: Set<CLLocationCoordinate2D> = [start]
    var cameFrom: [CLLocationCoordinate2D: CLLocationCoordinate2D] = [:]
    
    while !queue.isEmpty {
        let current = queue.removeFirst()
        
        if current == end {
            return reconstructPath(cameFrom: cameFrom, start: start, end: end)
        }
        
        for neighbor in neighbors(of: current) {
            if !visited.contains(neighbor) {
                queue.append(neighbor)
                visited.insert(neighbor)
                cameFrom[neighbor] = current
            }
        }
    }
    
    return nil
}
