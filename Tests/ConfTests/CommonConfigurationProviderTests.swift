import XCTest
@testable import Conf

final class CommonConfigurationProviderTests: XCTestCase {
    func testFetchError() {
        let fetcher: CommonConfigurationProvider.Fetcher = { throw TestError() }
        let parser: CommonConfigurationProvider.Parser = { _ in [:] }
        let provider = CommonConfigurationProvider(loader: fetcher, parser: parser)

        XCTAssertThrowsError(try provider.configuration()) { error in
            if case let ConfigurationError.fetch(detailError) = error {
                XCTAssertTrue(detailError is TestError)
            } else {
                XCTFail("Invalid error returned \(error)")
            }
        }
    }

    func testParserError() {
        let fetcher: CommonConfigurationProvider.Fetcher = { Data() }
        let parser: CommonConfigurationProvider.Parser = { _ in throw  TestError() }
        let provider = CommonConfigurationProvider(loader: fetcher, parser: parser)

        XCTAssertThrowsError(try provider.configuration()) { error in
            if case let ConfigurationError.parse(detailError) = error {
                XCTAssertTrue(detailError is TestError)
            } else {
                XCTFail("Invalid error returned \(error)")
            }
        }
    }

    func testDecodeError() {
        let fetcher: CommonConfigurationProvider.Fetcher = { Data() }
        let uuid = UUID()
        let parser: CommonConfigurationProvider.Parser = { data in
            return [
                "first": "value",
                "second": uuid
            ]
        }
        let provider = CommonConfigurationProvider(loader: fetcher, parser: parser)

        XCTAssertThrowsError(try provider.configuration()) { error in
            if case let ConfigurationError.decode(path: key, value: value) = error {
                XCTAssertEqual(key, "second")
                XCTAssertEqual(value as? UUID, uuid)
            } else {
                XCTFail("Invalid error returned \(error)")
            }
        }
    }

    func testDataFlow() throws {
        let data = "string".data(using: .utf8)!
        let fetcher: CommonConfigurationProvider.Fetcher = { data }
        let parser: CommonConfigurationProvider.Parser = { parserInput in
            XCTAssertEqual(parserInput, data)
            return [:]
        }
        let provider = CommonConfigurationProvider(loader: fetcher, parser: parser)
        let configuration = try provider.configuration()
        XCTAssertTrue(configuration.isEmpty)
    }

    func testDecodeValues() throws {
        let fetcher: CommonConfigurationProvider.Fetcher = { Data() }
        let parser: CommonConfigurationProvider.Parser = { _ in
            return [ "key": 22]
        }
        let provider = CommonConfigurationProvider(loader: fetcher, parser: parser)
        let configuration = try provider.configuration()
        XCTAssertEqual(configuration, ["key": "22"])
    }

    func testDecodeArray() throws {
        let fetcher: CommonConfigurationProvider.Fetcher = { Data() }
        let parser: CommonConfigurationProvider.Parser = { _ in
            return [ "key": ["one", "two"]]
        }
        let provider = CommonConfigurationProvider(loader: fetcher, parser: parser)
        let configuration = try provider.configuration()
        let expect: [Key: String] = [
            Key(["key", "0"]): "one",
            Key(["key", "1"]): "two"
        ]
        XCTAssertEqual(configuration, expect)
    }

    func testDecodeNestedValues() throws {
        let fetcher: CommonConfigurationProvider.Fetcher = { Data() }
        let parser: CommonConfigurationProvider.Parser = { _ in
            return [
                "key": [ "nested": "value" ],
                "one": [ "more": [
                    "deep": "value"
                    ]
                ]
            ]
        }
        let provider = CommonConfigurationProvider(loader: fetcher, parser: parser)
        let configuration = try provider.configuration()
        let expect: [Key: String] = [
            Key(["key", "nested"]): "value",
            Key(["one", "more", "deep"]): "value"
        ]
        XCTAssertEqual(configuration, expect)
    }

    func testDecodeEmptyValues() throws {
        let fetcher: CommonConfigurationProvider.Fetcher = { Data() }
        let parser: CommonConfigurationProvider.Parser = { _ in [:] }
        let provider = CommonConfigurationProvider(loader: fetcher, parser: parser)
        let configuration = try provider.configuration()
        XCTAssertEqual(configuration, [:])
    }

    func testDecodeEmptyArray() throws {
        let fetcher: CommonConfigurationProvider.Fetcher = { Data() }
        let parser: CommonConfigurationProvider.Parser = { _ in [ "key": []] }
        let provider = CommonConfigurationProvider(loader: fetcher, parser: parser)
        let configuration = try provider.configuration()
        XCTAssertEqual(configuration, [:])
    }
}
