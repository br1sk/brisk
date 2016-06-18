extension CollectionType {
    func find(@noescape predicate: (Generator.Element) throws -> Bool) rethrows -> Generator.Element? {
        let index = try self.indexOf(predicate)
        return index.flatMap { self[$0] }
    }
}
