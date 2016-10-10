@testable import Brisk
import Sonar
import XCTest

final class RadarSerializationTests: XCTestCase {
    func testSerializingRadar() {
        let radar = Radar(
            classification: .Security, product: .iOS, reproducibility: .Always, title: "title",
            description: "description", steps: "steps", expected: "expected", actual: "actual",
            configuration: "config", version: "version", notes: "notes", area: .Accessibility,
            applicationID: "456", userID: "123"
        )

        let json = try! radar.toData().toJsonDictionary() as NSDictionary?
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

        XCTAssertEqual(radar.actual, "actual")
        XCTAssertEqual(radar.applicationID, "456")
        XCTAssertEqual(radar.area?.appleIdentifier, Area.Accessibility.appleIdentifier)
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
    }
}

private func loadRadarJSON() -> [String: Any] {
    let url = Bundle(for: RadarSerializationTests.self).url(forResource: "radar", withExtension: "json")!
    return try! Data(contentsOf: url).toJsonDictionary()!
}
