import XCTest
@testable import Conf

final class DotEnvParserTests: XCTestCase {
    func testSuccess() throws {
        let content = try Resource(name: "valid", type: "env").data()
        let result = try Parser.donEnv(content)
        let expect = [
            "TZ": "Europe/Moscow",
            "PUID": "1026",
            "PGID": "100",
            "IP": "127.0.0.1"
        ]
        XCTAssertEqual(result as? [String: String], expect)
    }

    func testError() throws {
        let content = try Resource(name: "invalid", type: "env").data()
        XCTAssertThrowsError(try Parser.donEnv(content)) { error in
            XCTAssertTrue(error is Parser.InvalidFormat)
        }
    }
}
