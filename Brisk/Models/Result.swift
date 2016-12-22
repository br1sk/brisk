public enum Result<T, U: Error> {
    case success(T)
    case failure(U)

    public init(value: T?, failWith: @autoclosure () -> U) {
        if let value = value {
            self = .success(value)
        } else {
            self = .failure(failWith())
        }
    }
}
