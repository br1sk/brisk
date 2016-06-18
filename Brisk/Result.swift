enum Result<T, U: ErrorType> {
    case Success(T)
    case Failure(U)

    init(value: T?, @autoclosure failWith: () -> U) {
        if let value = value {
            self = .Success(value)
        } else {
            self = .Failure(failWith())
        }
    }
}
