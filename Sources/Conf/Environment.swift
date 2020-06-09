import Foundation

@dynamicMemberLookup
public struct Environment {
    public init(info: ProcessInfo = .processInfo) {
        self.info = info
    }

    private let info: ProcessInfo

    public func dump() -> [String: String] {
        info.environment
    }

    public subscript(_ key: String) -> String? {
        get { info.environment[key] }
        nonmutating set (value) {
            if let raw = value {
                setenv(key, raw, 1)
            } else {
                unsetenv(key)
            }
        }
    }

     public subscript(dynamicMember member: String) -> String? {
        get { self[member] }
        nonmutating set {  self[member] = newValue }
    }

    public subscript<Value>(_ key: String) -> Value? where Value: LosslessStringConvertible {
        get {
            let raw: String? = self[key]
            return raw.flatMap(Value.init)
        }
        nonmutating set (value) {
            self[key] = value?.description ?? nil
        }
    }

    public subscript<Value>(dynamicMember member: String) -> Value? where Value: LosslessStringConvertible {
        get { self[member] }
        nonmutating set (value) { self[member] = value }
    }

}
