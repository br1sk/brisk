extension Collection {
    func find(predicate: (Generator.Element) throws -> Bool) rethrows -> Generator.Element? {
        return try self.index(where: predicate).flatMap { self[$0] }
    }
}
