import AppKit
import Sonar

private struct DocumentError: ErrorType {}

final class RadarDocument: NSDocument {
    private var radar: Radar?

    override func makeWindowControllers() {
        self.createWindowController(withRadar: nil)
    }

    override func dataOfType(typeName: String) throws -> NSData {
        let viewController = self.windowControllers.first?.contentViewController as? RadarViewController
        guard let radar = viewController?.currentRadar() else {
            throw DocumentError()
        }

        return try radar.toData()
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        let object = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
        if let dictionary = object as? NSDictionary, let radar = Radar(JSON: dictionary) {
            self.createWindowController(withRadar: radar)
        } else {
            throw DocumentError()
        }
    }

    private func createWindowController(withRadar radar: Radar?) {
        let windowController = NSStoryboard.main.instantiateWindowControllerWithIdentifier("Radar")
        if let radar = radar {
            let viewController = windowController.contentViewController as! RadarViewController
            viewController.restoreRadar(radar)
        }

        self.addWindowController(windowController)
    }
}

private extension Radar {
    private func toData() throws -> NSData {
        var JSON: [String: AnyObject] = [
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

        return try NSJSONSerialization.dataWithJSONObject(JSON, options: [])
    }

    private init?(JSON: NSDictionary) {
        guard let title = JSON["title"] as? String,
            let description = JSON["description"] as? String,
            let classificationID = JSON["classification_id"] as? Int,
            let productID = JSON["product_id"] as? Int,
            let reproducibilityID = JSON["reproducibility_id"] as? Int,
            let steps = JSON["steps"] as? String,
            let expected = JSON["expected"] as? String,
            let actual = JSON["actual"] as? String,
            let configuration = JSON["configuration"] as? String,
            let version = JSON["version"] as? String,
            let notes = JSON["notes"] as? String else
        {
            return nil
        }

        let areaID = JSON["area_id"] as? Int
        let applicationID = JSON["application_id"] as? String
        let userID = JSON["user_id"] as? String

        let classification = Classification.All.find { $0.appleIdentifier == classificationID }
            ?? Classification.All.first!
        let reproducibility = Reproducibility.All.find { $0.appleIdentifier == reproducibilityID }
            ?? Reproducibility.All.first!
        let area = Area.All.find { $0.appleIdentifier == areaID } ?? Area.All.first!
        let product = Product.All.find { $0.appleIdentifier == productID } ?? Product.All.first!

        self.init(classification: classification, product: product, reproducibility: reproducibility,
                     title: title, description: description, steps: steps, expected: expected, actual: actual,
                     configuration: configuration, version: version, notes: notes, area: area,
                     applicationID: applicationID, userID: userID)
    }
}
