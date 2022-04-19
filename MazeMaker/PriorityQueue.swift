public enum PriorityWeighting {
  case lowestFirst, highestFirst
}

public class PriorityQueue<U: Hashable> {
  public typealias Pair = (item: U, priority: Int)

  fileprivate let heap: BinaryHeap<Pair>
  fileprivate var priorities: [U: Int] = [:]

  public var isEmpty: Bool {
    return heap.isEmpty
  }

  public init(compare: @escaping (Pair, Pair) -> HeapComparisonResult) {
    heap = BinaryHeap<Pair>(compare: compare)
  }

  public convenience init(weighting: PriorityWeighting) {
    let lowestFirst = { (a: Pair, b: Pair) -> HeapComparisonResult in
        if a.priority < b.priority {
          return .higher
        } else if a.priority > b.priority {
          return .lower
        } else {
          return .equal
        }
      }

    let highestFirst = { (a: Pair, b: Pair) -> HeapComparisonResult in
      if a.priority > b.priority {
        return .higher
      } else if a.priority < b.priority {
        return .lower
      } else {
        return .equal
      }
    }

    switch weighting {
    case .lowestFirst:
      self.init(compare: lowestFirst)
    case .highestFirst:
      self.init(compare: highestFirst)
    }
  }

  public subscript(element: U) -> Int? {
    get {
      return priorities[element]
    }

    set(newValue) {
      let newValue = newValue!

      if let priority = priorities[element] {
        _ = heap.deleteElement((element, priority))
      }

      heap.insert((element, newValue))
      priorities[element] = newValue
    }
  }

  public func fromCollection<S: Collection>(_ collection: S) where S.Iterator.Element == Pair {
    priorities.removeAll()

    for pair in collection {
      priorities[pair.item] = pair.priority
    }

    heap.buildHeap(collection)
  }

  public func next() -> Pair? {
    if let pair = heap.delete() {
      priorities.removeValue(forKey: pair.item)
      return pair
    }

    return nil
  }
}
