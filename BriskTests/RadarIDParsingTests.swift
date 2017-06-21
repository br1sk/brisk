import Brisk
import XCTest

final class RadarIDParsingTests: XCTestCase {
    func testParsingNormalRadarID() {
        XCTAssertEqual(radarID(from: "1234"), "1234")
    }

    func testParsingRadarString() {
        XCTAssertNil(radarID(from: "foobar"))
    }

    func testParsingRadarURL() {
        XCTAssertEqual(radarID(from: "rdar://1234"), "1234")
    }

    func testParsingProblemURL() {
        XCTAssertEqual(radarID(from: "rdar://problem/1234"), "1234")
    }
}
