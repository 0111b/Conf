import XCTest
@testable import Conf

final class KeyTests: XCTestCase {
    func testCreation() {
        let key1: Key = Key()
        XCTAssertEqual(key1.fragmets, [])
        let key2: Key = "24"
        XCTAssertEqual(key2.fragmets, ["24"])
        let key3: Key = 99
        XCTAssertEqual(key3.fragmets, ["99"])
        let key4: Key = Key(23.4)
        XCTAssertEqual(key4.fragmets, ["23.4"])
        let key5: Key = Key("some")
        XCTAssertEqual(key5.fragmets, ["some"])
        let key6: Key = ["24", 72, 23.4, true]
        XCTAssertEqual(key6.fragmets, ["24", "72", "23.4", "true"])
        let key7: Key = Key([1, 2, 3])
        XCTAssertEqual(key7.fragmets, ["1", "2", "3"])
    }
}
