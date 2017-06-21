import Brisk
import XCTest

final class DictionaryExtensionTests: XCTestCase {
    func testFilteringExceptStrings() {
        let dictionary: [String: Any] = ["foo": "bar", "baz": 1]
        let newDictionary = dictionary.onlyStrings()

        XCTAssertEqual(newDictionary.count, 1)
        XCTAssertEqual(newDictionary["foo"], "bar")
    }

    func testFilteringEmptyStrings() {
        let dictionary: [String: String] = ["foo": "", "bar": "baz"]
        let newDictionary = dictionary.filterEmpty()

        XCTAssertEqual(newDictionary.count, 1)
        XCTAssertEqual(newDictionary["bar"], "baz")
    }
}
