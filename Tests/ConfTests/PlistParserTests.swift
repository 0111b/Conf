import XCTest
@testable import Conf

final class PlistParserTests: XCTestCase {
    func testSuccess() throws {
        let content = try Resource(name: "valid", type: "plist").data()
        _ = try Parser.plist(content)
    }

    func testError() throws {
        let content = try Resource(name: "invalid", type: "plist").data()
        XCTAssertThrowsError(try Parser.plist(content)) { error in
            XCTAssertTrue(error is Parser.InvalidFormat)
        }
    }
}
