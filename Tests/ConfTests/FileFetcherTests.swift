import XCTest
@testable import Conf

final class FileFetcherTests: XCTestCase {
    func testSuccess() throws {
        let load = Fetcher.file("Tests/Resources/valid.env")
        _ = try load()
    }

    func testError() throws {
        let load = Fetcher.file("file that not exist")
        XCTAssertThrowsError(try load())
    }
}
