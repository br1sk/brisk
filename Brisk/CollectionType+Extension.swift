extension CollectionType {
    func find(@noescape predicate: (Generator.Element) throws -> Bool) rethrows -> Generator.Element? {
        return try self.indexOf(predicate).flatMap { self[$0] }
    }
}
