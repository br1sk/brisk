private let sectionToKeyPath: [String: WritableKeyPath<OpenRadar, String?>] = [
    "actual results": \.appendingToActual,
    "area": \.areaString,
    "configuration": \.configuration,
    "expected results": \.expected,
    "notes": \.notes,
    "observed results": \.appendingToActual,
    "steps to reproduce": \.steps,
    "summary": \.description,
    "version": \.version
]

public struct OpenRadar {
    public var actual: String?
    public var areaString: String?
    public var configuration: String?
    public var description: String?
    public var expected: String?
    public var notes: String?
    public var steps: String?
    public var version: String?
    fileprivate var appendingToActual: String? {
        get { return actual }
        set { actual = appendOrReturn(actual, newValue) }
    }

    fileprivate init() {}
}

public extension String {
    public func openRadarFromSummary() throws -> OpenRadar {
        let components = self.components(separatedBy: "\r\n")
        var openRadar = OpenRadar()
        var parts = [String]()
        var lastKeypath: WritableKeyPath<OpenRadar, String?>?

        for component in components {
            guard component.last == ":",
                let keyPath = sectionToKeyPath[String(component.dropLast()).lowercased()] else
            {
                parts.append(component)
                continue
            }

            if !parts.isEmpty && lastKeypath == nil {
                throw OpenRadarParsingError.invalidFormat
            }

            if let lastKeypath = lastKeypath {
                openRadar[keyPath: lastKeypath] = parts.joined(separator: "\r\n").strip()
            }
            parts = []
            lastKeypath = keyPath
        }

        if let keyPath = lastKeypath {
            if !parts.isEmpty {
                openRadar[keyPath: keyPath] = parts.joined(separator: "\r\n").strip()
            }
        } else {
            throw OpenRadarParsingError.invalidFormat
        }

        return openRadar
    }
}
