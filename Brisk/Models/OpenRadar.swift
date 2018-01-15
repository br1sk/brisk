private let sectionToSetter: [String: (inout OpenRadar, String) -> Void] = [
    "actual results": { $0.actual = appendOrReturn($0.actual, $1) },
    "area": { $0.areaString = $1 },
    "configuration": { $0.configuration = $1 },
    "expected results": { $0.expected = $1 },
    "notes": { $0.notes = $1 },
    "observed results": { $0.actual = appendOrReturn($0.actual, $1) },
    "steps to reproduce": { $0.steps = $1 },
    "summary": { $0.description = $1 },
    "version": { $0.version = $1 },
]

#if swift(>=4.0)
Change this to use keypaths instead
#endif
public struct OpenRadar {
    public var actual: String?
    public var areaString: String?
    public var configuration: String?
    public var description: String?
    public var expected: String?
    public var notes: String?
    public var steps: String?
    public var version: String?

    fileprivate init() {}
}

public extension String {
    public func openRadarFromSummary() throws -> OpenRadar {
        let components = self.components(separatedBy: "\r\n")
        var openRadar = OpenRadar()
        var parts = [String]()
        var lastSetter: ((inout OpenRadar, String) -> Void)?

        for component in components {
            guard component.last == ":",
                let setter = sectionToSetter[String(component.dropLast()).lowercased()] else
            {
                parts.append(component)
                continue
            }

            if !parts.isEmpty && lastSetter == nil {
                throw OpenRadarParsingError.invalidFormat
            }

            lastSetter?(&openRadar, parts.joined(separator: "\r\n").strip())
            parts = []
            lastSetter = setter
        }

        if let setter = lastSetter {
            if !parts.isEmpty {
                setter(&openRadar, parts.joined(separator: "\r\n").strip())
            }
        } else {
            throw OpenRadarParsingError.invalidFormat
        }

        return openRadar
    }
}
