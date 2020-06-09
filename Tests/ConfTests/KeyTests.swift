import XCTest
@testable import Conf

final class KeyTests: XCTestCase {
    func testCreation() {
        let k1: Key = Key()
        XCTAssertEqual(k1.fragmets, [])
        let k2: Key = "24"
        XCTAssertEqual(k2.fragmets, ["24"])
        let k3: Key = 99
        XCTAssertEqual(k3.fragmets, ["99"])
        let k4: Key = Key(23.4)
        XCTAssertEqual(k4.fragmets, ["23.4"])
        let k5: Key = Key("some")
        XCTAssertEqual(k5.fragmets, ["some"])
        let k6: Key = ["24", 72, 23.4, true]
        XCTAssertEqual(k6.fragmets, ["24", "72", "23.4", "true"])
        let k7: Key = Key([1,2,3])
        XCTAssertEqual(k7.fragmets, ["1", "2", "3"])
    }
}
