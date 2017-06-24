import Brisk
import Sonar
import XCTest

final class OpenRadarTests: XCTestCase {
    func testDeserializingJSON() {
        let json = loadOpenRadarJSON()
        guard let radar = try? Radar(openRadar: json) else {
            return XCTFail("Failed to deserializing open radar JSON")
        }

        XCTAssertEqual(radar.classification, .OtherBug)
        XCTAssertEqual(radar.product, .DeveloperTools)
        XCTAssertEqual(radar.reproducibility, .Always)
        XCTAssertEqual(radar.version, "Xcode 9.0")
        XCTAssertEqual(radar.configuration, "")
        XCTAssertEqual(radar.title, "Some title")
        XCTAssertEqual(radar.description, "This is a duplicate of radar #1234\n\nfoo\n\nbar\nbaz\n")
        XCTAssertEqual(radar.steps, "1. foo\n2. bar")
        XCTAssertEqual(radar.expected, "foo")
        XCTAssertEqual(radar.actual, "bar")
        XCTAssertEqual(radar.version, "Xcode 9.0")
        XCTAssertEqual(radar.notes, "some notes")
    }

    func testOpenRadarMissingResult() {
        do {
            _ = try Radar(openRadar: [:])
            XCTFail("Radar shouldn't be valid")
        } catch let error as OpenRadarParsingError {
            XCTAssertEqual(error, .noResult)
        } catch {
            XCTFail("Got invalid error")
        }
    }

    func testOpenRadarMissingTitle() {
        do {
            _ = try Radar(openRadar: ["result": [:]])
            XCTFail("Radar shouldn't be valid")
        } catch let error as OpenRadarParsingError {
            XCTAssertEqual(error, .missingRequiredFields)
        } catch {
            XCTFail("Got invalid error")
        }
    }

    func testObservedAndActualAppend() {
        let string = "Observed results:\r\nfoo\r\nActual Results:\r\nbar"
        guard let openRadar = try? string.openRadarFromSummary() else {
            return XCTFail("Failed to parse valid description")
        }

        XCTAssertEqual(openRadar.actual, "foo\nbar")
    }

    func testParsingOpenRadar() {
        guard let openRadar = try? loadOpenRadarString(.regular).openRadarFromSummary() else {
            return XCTFail("Failed to parse valid description")
        }

        XCTAssertEqual(openRadar.description, "foo\n\nbar\nbaz")
        XCTAssertEqual(openRadar.steps, "1. foo\n2. bar")
        XCTAssertEqual(openRadar.expected, "foo")
        XCTAssertEqual(openRadar.actual, "bar")
        XCTAssertEqual(openRadar.version, "Xcode 9.0")
        XCTAssertEqual(openRadar.notes, "some notes")
        XCTAssertEqual(openRadar.configuration, "some config")
    }

    func testParsingArea() {
        guard let openRadar = try? "Area:\r\nfoo".openRadarFromSummary() else {
            return XCTFail("Failed to parse valid description")
        }

        XCTAssertEqual(openRadar.areaString, "foo")
    }

    func testParsingLongerOpenRadar() {
        guard let openRadar = try? loadOpenRadarString(.long).openRadarFromSummary() else {
            return XCTFail("Failed to parse valid radar")
        }

        XCTAssertEqual(openRadar.description, "foo\n\nbar\nbaz\n\nqux\n\nfoo\nbar\n\nbaz\n\nqux")
        XCTAssertEqual(openRadar.steps, "foo")
        XCTAssertEqual(openRadar.expected, "bar")
        XCTAssertEqual(openRadar.actual, "baz")
        XCTAssertEqual(openRadar.version, "foo")
        XCTAssertNil(openRadar.notes)
    }

    func testParsingPartiallyValidRadar() {
        do {
            _ = try "foo.\r\n\r\nSummary:\r\nbar\r\nbaz".openRadarFromSummary()
            XCTFail("Open radar should be invalid")
        } catch let error as OpenRadarParsingError {
            XCTAssertEqual(error, .invalidFormat)
        } catch let error {
            XCTFail("Invalid error thrown: \(error)")
        }
    }

    func testParsingUnformattedOpenRadar() {
        do {
            _ = try "foo.\r\n\r\nbar\r\nbaz".openRadarFromSummary()
            XCTFail("Open radar should be invalid")
        } catch let error as OpenRadarParsingError {
            XCTAssertEqual(error, .invalidFormat)
        } catch let error {
            XCTFail("Invalid error thrown: \(error)")
        }
    }

}

private enum StringID: String {
    case regular
    case long
}

private func loadOpenRadarString(_ stringID: StringID) -> String {
    let url = Bundle(for: OpenRadarTests.self).url(forResource: "openradarstrings", withExtension: "json")!
    return try! Data(contentsOf: url).toJSONDictionary()!.onlyStrings()[stringID.rawValue]!
}

private func loadOpenRadarJSON() -> [String: Any] {
    let url = Bundle(for: OpenRadarTests.self).url(forResource: "openradar", withExtension: "json")!
    return try! Data(contentsOf: url).toJSONDictionary()!
}
