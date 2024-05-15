import Foundation

struct PriorityQueue<T: Hashable> {
    private var elements: [T]
    private let priorityFunction: (T, T) -> Bool

    init(elements: [T] = [], priorityFunction: @escaping (T, T) -> Bool) {
        self.elements = elements
        self.priorityFunction = priorityFunction
        buildHeap()
    }

    var isEmpty: Bool {
        return elements.isEmpty
    }

    mutating func enqueue(_ element: T) {
        elements.append(element)
        siftUp(elementAtIndex: elements.count - 1)
    }

    mutating func dequeue() -> T? {
        guard !elements.isEmpty else { return nil }
        if elements.count == 1 {
            return elements.removeFirst()
        } else {
            let value = elements[0]
            elements[0] = elements.removeLast()
            siftDown(elementAtIndex: 0)
            return value
        }
    }

    private mutating func buildHeap() {
        for index in (0..<(elements.count / 2)).reversed() {
            siftDown(elementAtIndex: index)
        }
    }

    private mutating func siftUp(elementAtIndex index: Int) {
        let parent = (index - 1) / 2
        guard !isRoot(index), isHigherPriority(at: index, than: parent) else { return }
        swapElement(at: index, with: parent)
        siftUp(elementAtIndex: parent)
    }

    private mutating func siftDown(elementAtIndex index: Int) {
        let childIndex = highestPriorityIndex(for: index)
        if index == childIndex {
            return
        }
        swapElement(at: index, with: childIndex)
        siftDown(elementAtIndex: childIndex)
    }

    private func isRoot(_ index: Int) -> Bool {
        return index == 0
    }

    private func leftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }

    private func rightChildIndex(of index: Int) -> Int {
        return (2 * index) + 2
    }

    private func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }

    private func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < elements.count else { return parentIndex }
        return isHigherPriority(at: childIndex, than: parentIndex) ? childIndex : parentIndex
    }

    private func highestPriorityIndex(for parent: Int) -> Int {
        return highestPriorityIndex(
            of: highestPriorityIndex(of: parent, and: leftChildIndex(of: parent)),
            and: rightChildIndex(of: parent)
        )
    }

    private mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        elements.swapAt(firstIndex, secondIndex)
    }
}
