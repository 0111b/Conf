///  Key-value storage that can be filled from multiple sources
public final class Config {
    public init(useEnvironment: Bool = false) {
        isBackedByEnvironment = useEnvironment
    }

    let isBackedByEnvironment: Bool
    private let environment = Environment()
    private var data = [Key: String]()

    func value(for key: Key) -> String? {
        return data[key] ?? envValue(for: key)
    }

    func envValue(for key: Key) -> String? {
        guard isBackedByEnvironment,
            key.path.count == 1,
            let variable = key.path.first
            else { return nil }
        return environment[variable]
    }

    func set(value: String?, for key: Key) {
        data[key] = value
    }

    public subscript(_ key: Key) -> String? {
        get { value(for: key) }
        set { set(value: newValue, for: key) }
    }

    public subscript<Value>(_ key: Key) -> Value? where Value: LosslessStringConvertible {
        get { value(for: key).flatMap(Value.init) }
        set { set(value: newValue?.description, for: key) }
    }

    public func dump() -> [Key: String] {
        data
    }

    public func load(from provider: ConfigurationProvider) throws {
        try data.merge(provider.configuration(),
                       uniquingKeysWith: { _, new in new })
    }
}
