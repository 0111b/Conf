import XCTest
@testable import Conf

final class JSONParserTests: XCTestCase {
    func testSuccess() throws {
        let content = try Resource(name: "valid", type: "json").data()
        _ = try Parser.json(content)
    }

    func testError() throws {
        let content = try Resource(name: "invalid", type: "json").data()
        XCTAssertThrowsError(try Parser.json(content)) { error in
            XCTAssertTrue(error is Parser.InvalidFormat)
        }
    }
}
