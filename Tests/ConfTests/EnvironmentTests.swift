import XCTest
@testable import Conf

final class EnvironmentTests: XCTestCase {

    static let sampleValues: [String: String] = [
        "first": "string",
        "integer": "1",
        "float": "2.33",
        "booleanTrue": "true",
        "booleanFalse": "false",
        "YES": "YES"
    ]

    func testDump() throws {
        let values = Self.sampleValues
        let info = ProcessInfo.make(with: values)
        let env = Environment(info: info)

        let dumped = env.dump()

        XCTAssertEqual(values, dumped)
    }

    func testRead() throws {
        let info = ProcessInfo.make(with: Self.sampleValues)
        let env = Environment(info: info)

        XCTAssertNil(env.blabla)
        XCTAssertNil(env["blabla"])

        XCTAssertEqual(env.first, "string")
        XCTAssertNil(env.first as Int?)
        XCTAssertEqual(env["first"], "string")
        XCTAssertNil(env["first"] as Int?)

        XCTAssertEqual(env.integer as Int?, 1)
        XCTAssertEqual(env.integer, "1")
        XCTAssertEqual(env["integer"] as Int?, 1)
        XCTAssertEqual(env["integer"], "1")

        XCTAssertEqual(env.float, "2.33")
        XCTAssertEqual(env.float as Double?, 2.33)
        XCTAssertEqual(env.float as Float?, 2.33)
        XCTAssertNil(env.float as Int?)
        XCTAssertEqual(env["float"], "2.33")
        XCTAssertEqual(env["float"] as Double?, 2.33)
        XCTAssertEqual(env["float"] as Float?, 2.33)
        XCTAssertNil(env["float"] as Int?)

        XCTAssertEqual(env.booleanTrue, "true")
        XCTAssertEqual(env.booleanTrue as Bool?, true)
        XCTAssertNil(env.booleanTrue as Int?)
        XCTAssertEqual(env["booleanTrue"], "true")
        XCTAssertEqual(env["booleanTrue"] as Bool?, true)
        XCTAssertNil(env["booleanTrue"] as Int?)

        XCTAssertEqual(env.booleanFalse, "false")
        XCTAssertEqual(env.booleanFalse as Bool?, false)
        XCTAssertNil(env.booleanFalse as Int?)
        XCTAssertEqual(env["booleanFalse"], "false")
        XCTAssertEqual(env["booleanFalse"] as Bool?, false)
        XCTAssertNil(env["booleanFalse"] as Int?)

        XCTAssertEqual(env.YES, "YES")
        XCTAssertNil(env.YES as Bool?)
    }

    func testAdd() {
        let env = Environment(info: ProcessInfo.instance)

        XCTAssertNil(env.key1)
        env.key1 = "value1"
        XCTAssertEqual(env.key1, "value1")

        XCTAssertNil(env.key2)
        env["key2"] = "value2"
        XCTAssertEqual(env.key2, "value2")
    }

    func testRemove() {
        let env = Environment(info: ProcessInfo.instance)
        env.key1 = "value1"

        XCTAssertEqual(env.key1, "value1")
        env.key1 = nil
        XCTAssertNil(env.key1)

        env["key2"] = "value2"
        XCTAssertEqual(env["key2"], "value2")
        env["key2"] = nil
        XCTAssertNil(env["key2"])
    }

    func testUpdate() {
        let env = Environment(info: ProcessInfo.instance)
        env.key1 = "value"

        XCTAssertEqual(env.key1, "value")
        env.key1 = "new value"
        XCTAssertEqual(env.key1, "new value")
    }

    func testWrite() {
        let env = Environment(info: ProcessInfo.instance)

        let int = Int.random(in: Int.min...Int.max)
        env.int = int
        XCTAssertEqual(env.int, int)

        let float = Float.random(in: 0...100)
        env.float = float
        XCTAssertEqual(env.float, float)

        env.success = true
        XCTAssertEqual(env.success, true)

        env.failure = false
        XCTAssertEqual(env.failure, false)
    }
}
