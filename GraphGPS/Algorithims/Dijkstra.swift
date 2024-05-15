import Foundation
import CoreLocation

func dijkstra(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> [CLLocationCoordinate2D]? {
    var distances: [CLLocationCoordinate2D: Double] = [start: 0]
    var priorityQueue: PriorityQueue<CLLocationCoordinate2D> = PriorityQueue(elements: [start], priorityFunction: { distances[$0]! < distances[$1]! })
    var cameFrom: [CLLocationCoordinate2D: CLLocationCoordinate2D] = [:]
    
    while !priorityQueue.isEmpty {
        let current = priorityQueue.dequeue()!
        
        if current == end {
            return reconstructPath(cameFrom: cameFrom, start: start, end: end)
        }
        
        for neighbor in neighbors(of: current) {
            let newDist = distances[current]! + distance(from: current, to: neighbor)
            if newDist < (distances[neighbor] ?? Double.infinity) {
                distances[neighbor] = newDist
                priorityQueue.enqueue(neighbor)
                cameFrom[neighbor] = current
            }
        }
    }
    
    return nil
}
