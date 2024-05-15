import Foundation
import CoreLocation

func dfs(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> [CLLocationCoordinate2D]? {
    var stack: [CLLocationCoordinate2D] = [start]
    var visited: Set<CLLocationCoordinate2D> = [start]
    var cameFrom: [CLLocationCoordinate2D: CLLocationCoordinate2D] = [:]
    
    while !stack.isEmpty {
        let current = stack.removeLast()
        
        if current == end {
            return reconstructPath(cameFrom: cameFrom, start: start, end: end)
        }
        
        for neighbor in neighbors(of: current) {
            if !visited.contains(neighbor) {
                stack.append(neighbor)
                visited.insert(neighbor)
                cameFrom[neighbor] = current
            }
        }
    }
    
    return nil
}
