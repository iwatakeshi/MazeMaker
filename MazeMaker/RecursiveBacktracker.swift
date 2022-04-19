public class RecursiveBacktracker : Algorithm {
  public init() { }

  public func applyTo(_ grid: Grid) {
    var stack = [ grid.sample() ]

    while (stack.count > 0) {
      let cell = stack.last!
      let neighbors = cell.neighbors.filter({$0.links.isEmpty})

      if let neighbor = neighbors.sample() {
        cell.linkWith(neighbor)
        stack.append(neighbor)
      } else {
        _ = stack.popLast()
      }
    }
  }
}
