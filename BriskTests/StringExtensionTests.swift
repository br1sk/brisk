import Brisk
import XCTest

final class StringExtensionTests: XCTestCase {
    func testAppendOrReturnBothExist() {
        XCTAssertEqual(appendOrReturn("foo", "bar"), "foo\nbar")
    }

    func testAppendOrReturnBothNil() {
        XCTAssertEqual(appendOrReturn(nil, nil), nil)
    }

    func testAppendOrReturnFirstString() {
        XCTAssertEqual(appendOrReturn("foo", nil), "foo")
    }

    func testAppendOrReturnSecondString() {
        XCTAssertEqual(appendOrReturn(nil, "bar"), "bar")
    }
}
