public class Cell: Hashable {
  fileprivate(set) var links : Set<Cell> = []
  public fileprivate(set) var location : Location

  public func hash(into hasher: inout Hasher) {
    hasher.combine(location.hashValue)
  }

  public var neighbors: Set<Cell> {
    preconditionFailure("neighbors must be overridden in subclasses");
  }

  public init(location: Location) {
    self.location = location
  }

  func linkOnceWith(_ neighbor: Cell) {
    links.insert(neighbor)
  }

  func unlinkOnceFrom(_ neighbor: Cell) {
    links.remove(neighbor)
  }

  public func linkWith(_ neighbor: Cell) {
    linkOnceWith(neighbor)
    neighbor.linkOnceWith(self)
  }

  public func unlinkFrom(_ neighbor: Cell) {
    unlinkOnceFrom(neighbor)
    neighbor.unlinkOnceFrom(self)
  }

  public func isLinkedWith(_ neighbor: Cell?) -> Bool {
    if let neighbor = neighbor {
      return links.contains(neighbor)
    } else {
      return false
    }
  }

  public func isDeadEnd() -> Bool {
    return links.count == 1
  }

  public func reset() {
    links.removeAll()
  }
}

public func ==(lhs: Cell, rhs: Cell) -> Bool {
  return lhs.location == rhs.location
}
