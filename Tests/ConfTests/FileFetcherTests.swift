import XCTest
@testable import Conf

final class FileFetcherTests: XCTestCase {
    func testSuccess() throws {
        let path = Resource.resourceFolderURL.appendingPathComponent("valid.env").path()
        let load = Fetcher.file(path)
        _ = try load()
    }

    func testError() throws {
        let load = Fetcher.file("file that not exist")
        XCTAssertThrowsError(try load())
    }
}
