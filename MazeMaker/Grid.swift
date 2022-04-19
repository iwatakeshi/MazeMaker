public class Grid {
  public fileprivate(set) var cells: Set<Cell> = Set<Cell>()
  fileprivate var slots: [Location : Cell] = [:]

  public fileprivate(set) var layout: Layout

  public init(layout: Layout) {
    self.layout = layout
    layout.build(self)
  }
  
  @discardableResult
  public func add(_ cell: Cell) -> Self {
    cells.insert(cell)
    slots[cell.location] = cell
    return self
  }

  public func remove(_ cell: Cell) -> Self {
    cells.remove(cell)
    slots.removeValue(forKey: cell.location)
    return self
  }

  public func at(_ location: Location) -> Cell? {
    return slots[location]
  }

  public func reset() -> Self {
    for cell in cells {
      cell.reset()
    }

    return self
  }

  public func sample() -> Cell {
    precondition(cells.count > 0, "cannot sample an empty grid")
    return cells.sample()!
  }

  public func braid(_ p: Float = 0.5) {
    let deadends = cells.filter { $0.isDeadEnd() }.shuffle()
    let count = Int(ceilf(Float(deadends.count) * p))

    for i in 0..<count {
      let cell = deadends[i]
      let neighbor = cell.neighbors.filter { !cell.isLinkedWith($0) }.sample()

      if let neighbor = neighbor {
        cell.linkWith(neighbor)
      }
    }
  }

  public func distancesFromCell(_ cell: Cell) -> Distances {
    let distances = Distances(root: cell)
    let queue = PriorityQueue<Cell>(weighting: .lowestFirst)
    queue.fromCollection(cells.map { ($0, ($0 == cell) ? 0 : Int.max) })

    while !queue.isEmpty {
      let current = queue.next()!
      let nextDistance = current.priority + 1

      for neighbor in current.item.links {
        if nextDistance < queue[neighbor] ?? 0 {
          queue[neighbor] = nextDistance
          distances[neighbor] = nextDistance
        }
      }
    }

    return distances
  }

  public func toString() -> String {
    return layout.renderAsString(self)
  }
}
