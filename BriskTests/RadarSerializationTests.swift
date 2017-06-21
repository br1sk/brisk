import Brisk
import Sonar
import XCTest

private extension Area {
    init(appleIdentifier: Int, name: String) {
        self.appleIdentifier = appleIdentifier
        self.name = name
    }
}

final class RadarSerializationTests: XCTestCase {
    func testSerializingRadar() {
        let attachment = Attachment(filename: "foo.png", mimeType: "image/png",
                                    data: Data(base64Encoded: "")!)
        let area = Area.areas(for: Product.iOS).first!
        let radar = Radar(
            classification: .Security, product: .iOS, reproducibility: .Always, title: "title",
            description: "description", steps: "steps", expected: "expected", actual: "actual",
            configuration: "config", version: "version", notes: "notes", attachments: [attachment],
            area: area, applicationID: "456", userID: "123"
        )

        let json = try! radar.toData().toJSONDictionary() as NSDictionary?
        let realJson = loadRadarJSON() as NSDictionary
        XCTAssertEqual(json, realJson)
    }

    func testCreatingInvalidRadar() {
        let json = [String: Any]()
        let radar = Radar(json: json)
        XCTAssertNil(radar)
    }

    func testDeserializingRadar() {
        let radar = Radar(json: loadRadarJSON())!
        let attachment = radar.attachments.first!

        XCTAssertEqual(radar.actual, "actual")
        XCTAssertEqual(radar.applicationID, "456")
        XCTAssertEqual(radar.area?.appleIdentifier, 1)
        XCTAssertEqual(radar.classification.appleIdentifier, Classification.Security.appleIdentifier)
        XCTAssertEqual(radar.configuration, "config")
        XCTAssertEqual(radar.description, "description")
        XCTAssertEqual(radar.expected, "expected")
        XCTAssertEqual(radar.notes, "notes")
        XCTAssertEqual(radar.product.appleIdentifier, Product.iOS.appleIdentifier)
        XCTAssertEqual(radar.reproducibility.appleIdentifier, Reproducibility.Always.appleIdentifier)
        XCTAssertEqual(radar.steps, "steps")
        XCTAssertEqual(radar.title, "title")
        XCTAssertEqual(radar.userID, "123")
        XCTAssertEqual(radar.version, "version")
        XCTAssertEqual(radar.version, "version")
        XCTAssertEqual(attachment.filename, "foo.png")
        XCTAssertEqual(attachment.mimeType, "image/png")
        XCTAssertEqual(attachment.data, Data(base64Encoded: "")!)
    }
}

private func loadRadarJSON() -> [String: Any] {
    let url = Bundle(for: RadarSerializationTests.self).url(forResource: "radar", withExtension: "json")!
    return try! Data(contentsOf: url).toJSONDictionary()!
}
