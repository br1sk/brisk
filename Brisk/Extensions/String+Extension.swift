public extension String {
    public func strip() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

public func appendOrReturn(_ string1: String?, _ string2: String?) -> String? {
    if let string1 = string1, let string2 = string2 {
        return string1 + "\n" + string2
    }

    return string1 ?? string2
}
