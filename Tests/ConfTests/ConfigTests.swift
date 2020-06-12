import XCTest
@testable import Conf

final class ConfigTests: XCTestCase {

    var config: Config!

    override func setUpWithError() throws {
        config = Config()
    }

    func testEnvironmentUse() {
        XCTAssertNil(Config(useEnvironment: false)["PATH"])
        XCTAssertNotNil(Config(useEnvironment: true)["PATH"])
    }

    func testLoadConfigThrow() {
        let errorConfigProvider = MockConfigurationProvider(config: [:], error: TestError())

        XCTAssertThrowsError(try config.load(from: errorConfigProvider)) { error in
            XCTAssertTrue(error is TestError)
        }
    }

    func testLoadConfigSuccess() throws {
        let loader = MockConfigurationProvider(config: ["key": "value"])
        try config.load(from: loader)
        XCTAssertEqual(config.dump(), [Key("key"): "value"])
    }

    func testWrite() {
        let key: Key = "key"
        XCTAssertEqual(config.dump(), [:])
        config.set(value: "value", for: key)
        XCTAssertEqual(config.dump(), [Key("key"): "value"])
        config.set(value: nil, for: key)
        XCTAssertEqual(config.dump(), [:])
        config.set(value: "another value", for: ["long", "path"])
        XCTAssertEqual(config.dump(), [Key(["long", "path"]): "another value"])

        config["subscript"] = "subscriptValue"
        XCTAssertEqual(config.dump()["subscript"], "subscriptValue")

        config["lossless"] = 42
        XCTAssertEqual(config.dump()["lossless"], "42")
    }

    func testRead() throws {
        let loader = MockConfigurationProvider(config: [
            "string": "value",
            "int": "42",
            "double": "23.5"
        ])
        try config.load(from: loader)
        XCTAssertEqual(config["blabla"], nil)
        XCTAssertEqual(config["string"], "value")
        XCTAssertEqual(config["int"], "42")
        XCTAssertEqual(config["int"], 42)
        XCTAssertEqual(config["double"], "23.5")
        XCTAssertEqual(config["double"], 23.5)
    }

    func testRequire() throws {
        XCTAssertThrowsError(try config.require("missingString")) { error in
            if case let ConfigurationError.missing(key: key) = error {
                XCTAssertEqual(key, "missingString")
            } else {
                XCTFail("Invalid error type \(error)")
            }
        }

        XCTAssertThrowsError(try config.require("missingLossless") as Int?) { error in
            if case let ConfigurationError.missing(key: key) = error {
                XCTAssertEqual(key, "missingLossless")
            } else {
                XCTFail("Invalid error type \(error)")
            }
        }

        config["intKey"] = 42
        try  XCTAssertEqual("42", config.require("intKey"))
        try  XCTAssertEqual(42, config.require("intKey"))
    }

}

struct MockConfigurationProvider: ConfigurationProvider {
    var config: [Key: String]
    var error: Error?
    func configuration() throws -> [Key: String] {
        if let error = self.error { throw error }
        return config
    }
}
