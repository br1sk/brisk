import Brisk
import XCTest

private struct TestError: Error {}

final class ResultTests: XCTestCase {
    func testCreatingSuccessfully() {
        let result = Result(value: "hi", failWith: TestError())
        if case .success(let value) = result {
            XCTAssertEqual(value, "hi")
        } else {
            XCTFail("Result should have been successful")
        }
    }

    func testCreatingError() {
        let result = Result<String, TestError>(value: nil, failWith: TestError())
        switch result {
            case .failure:
                break
            default:
                XCTFail("Didn't create error")
        }
    }
}
