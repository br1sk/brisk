import Sonar

public enum OpenRadarParsingError: Error {
    case noResult
    case missingRequiredFields
    case invalidFormat
}

public extension Radar {
    public init(openRadar json: [String: Any]) throws {
        guard let dictionary = json["result"] as? [String: Any] else {
            throw OpenRadarParsingError.noResult
        }

        let json = dictionary.onlyStrings().filterEmpty()
        guard let title = json["title"], let description = json["description"] else {
            throw OpenRadarParsingError.missingRequiredFields
        }

        let classificationString = json["classification"]?.lowercased()
        let classification = Classification.All.first { $0.name.lowercased() == classificationString }
            ?? Classification.All.first!
        let productString = json["product"]?.lowercased()
        let product = Product.All.first { $0.name.lowercased() == productString } ?? Product.All.first!

        let reproducibilityString = json["reproducible"]?.lowercased()
        let reproducibility = Reproducibility.All.first { $0.name.lowercased() == reproducibilityString }
            ?? Reproducibility.All.first!

        // Pick the last area (if there are any for the product) instead of defaulting to the first one from
        // the UI. Ideally we just wouldn't pick one in this case
        let lastArea = Area.areas(for: product).last

        let productVersion = json["product_version"]
        let radarID = json["number"]

        do {
            let openRadar = try description.openRadarFromSummary()
            let version = productVersion ?? openRadar.version ?? " "
            let updatedDescription = summary(for: radarID, description: openRadar.description ?? description)
            let area = Area.areas(for: product)
                .first { $0.name.lowercased() == openRadar.areaString?.lowercased() }

            self.init(classification: classification, product: product, reproducibility: reproducibility,
                      title: title, description: updatedDescription, steps: openRadar.steps ?? " ",
                      expected: openRadar.expected ?? " ", actual: openRadar.actual ?? " ",
                      configuration: openRadar.configuration ?? version, version: version,
                      notes: openRadar.notes ?? " ", attachments: [], area: area ?? lastArea)

        } catch is OpenRadarParsingError {
            let updatedDescription = summary(for: radarID, description: description)
            let version = productVersion ?? " "

            self.init(classification: classification, product: product, reproducibility: reproducibility,
                      title: title, description: updatedDescription, steps: " ", expected: " ", actual: " ",
                      configuration: version, version: version, notes: " ", attachments: [], area: lastArea)

        } catch let error {
            assertionFailure("Got unexpected error type \(error)")
            throw error
        }
    }
}

private func summary(for radarID: String?, description: String) -> String {
    return radarID.map { "This is a duplicate of radar #\($0)\n\n\(description)\n" } ?? description
}
