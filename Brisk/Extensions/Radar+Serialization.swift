import Sonar

public extension Radar {
    func toData() throws -> Data {
        var JSON: [String: Any] = [
            "title": self.title,
            "description": self.description,
            "classification_id": self.classification.appleIdentifier,
            "product_id": self.product.appleIdentifier,
            "reproducibility_id": self.reproducibility.appleIdentifier,
            "steps": self.steps,
            "expected": self.expected,
            "actual": self.actual,
            "configuration": self.configuration,
            "version": self.version,
            "notes": self.notes,
        ]

        JSON["area_id"] = self.area?.appleIdentifier
        JSON["application_id"] = self.applicationID
        JSON["user_id"] = self.userID
        JSON["attachments"] = self.attachments.map { $0.toJSON() }

        return try JSONSerialization.data(withJSONObject: JSON, options: [])
    }

    public init?(json: [String: Any]) {
        guard let title = json["title"] as? String,
            let description = json["description"] as? String,
            let classificationID = json["classification_id"] as? Int,
            let productID = json["product_id"] as? Int,
            let reproducibilityID = json["reproducibility_id"] as? Int,
            let steps = json["steps"] as? String,
            let expected = json["expected"] as? String,
            let actual = json["actual"] as? String,
            let configuration = json["configuration"] as? String,
            let version = json["version"] as? String,
            let notes = json["notes"] as? String else
        {
            return nil
        }

        let areaID = json["area_id"] as? Int
        let applicationID = json["application_id"] as? String
        let userID = json["user_id"] as? String
        let attachments = (json["attachments"] as? [[String: Any]] ?? []).flatMap(Attachment.init)

        let classification = Classification.All.first { $0.appleIdentifier == classificationID }
            ?? Classification.All.first!
        let reproducibility = Reproducibility.All.first { $0.appleIdentifier == reproducibilityID }
            ?? Reproducibility.All.first!
        let product = Product.All.first { $0.appleIdentifier == productID } ?? Product.All.first!
        let area = Area.areas(for: product).first { $0.appleIdentifier == areaID }

        self.init(classification: classification, product: product, reproducibility: reproducibility,
                     title: title, description: description, steps: steps, expected: expected, actual: actual,
                     configuration: configuration, version: version, notes: notes,
                     attachments: attachments, area: area, applicationID: applicationID, userID: userID)
    }
}
