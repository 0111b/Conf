import XCTest
@testable import Conf

final class ParserJSONTests: XCTestCase {
    func testSuccess() throws {
        let content = try Resource(name: "valid", type: "json").data()
        _ = try Parser.json(content)
    }

    func testError() throws {
        let content = try Resource(name: "invalid", type: "json").data()
        XCTAssertThrowsError(try Parser.json(content)) { error in
            guard case ConfigurationError.parse = error else {
                XCTFail("Invalid error returned \(error)")
                return
            }
        }
    }
}
