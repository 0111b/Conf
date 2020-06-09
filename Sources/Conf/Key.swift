/// Configuration key that points to the value
public struct Key {

    let fragmets: [String]

    public init(_ value: LosslessStringConvertible) {
        fragmets = [value.description]
    }

    public init(_ elements: [LosslessStringConvertible]) {
        fragmets = elements.map(\.description)
    }

    public init(_ elements: LosslessStringConvertible...) {
        self.init(elements)
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
        "Key<\(fragmets.description)>"
    }
}
