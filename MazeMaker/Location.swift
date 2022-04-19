public class Location: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(0)
  }
  public func isEqual(_ location: Location) -> Bool {
    return hashValue == location.hashValue
  }
}

public func ==(lhs: Location, rhs: Location) -> Bool {
  return lhs.isEqual(rhs)
}
