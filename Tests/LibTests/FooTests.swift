import XCTest
@testable import Lib

final class FooTests: XCTestCase {

    func testFoo() throws {
        XCTAssertEqual(42, foo())
    }
}
