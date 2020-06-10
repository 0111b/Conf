/// Configuration key that points to the value
public struct Key {

    let path: [String]

    public init(_ value: LosslessStringConvertible) {
        path = [value.description]
    }

    public init(_ elements: [LosslessStringConvertible]) {
        path = elements.map(\.description)
    }

    public init(_ elements: LosslessStringConvertible...) {
        self.init(elements)
    }

    func child(key: String) -> Key {
        Key(path + [key])
    }
}

extension Key: Equatable {}
extension Key: Hashable {}

extension Key: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: LosslessStringConvertible...) {
        self.init(elements)
    }
}

extension Key: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension Key: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

extension Key: CustomStringConvertible {
    public var description: String {
        "Key<\(path.description)>"
    }
}
