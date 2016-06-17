@testable import Brisk
import XCTest

final class CollectionTypeExtensionTests: XCTestCase {
    func testFindMatching() {
        let array = [1, 2, 3]
        let element = array.find { $0 == 2 }

        XCTAssertEqual(element, 2)
    }

    func testFindMissing() {
        let array = [1, 2, 3]
        let element = array.find { $0 == 4 }

        XCTAssertNil(element)
    }
}
