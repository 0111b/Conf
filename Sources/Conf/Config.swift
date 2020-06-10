/// Key-value storage that can be filled from multiple sources
public final class Config {
    /// Returns new config
    /// - Parameter useEnvironment: if `true` fallback to the environment values for missing keys
    public init(useEnvironment: Bool = false) {
        isBackedByEnvironment = useEnvironment
    }

    /// if `true` fallback to the environment values for missing keys
    let isBackedByEnvironment: Bool
    private let environment = Environment()
    private var data = [Key: String]()

    /// Returns value associated with the given `key`
    func value(for key: Key) -> String? {
        return data[key] ?? envValue(for: key)
    }

    /// Asks enviroment about value associated with the given `key`
    func envValue(for key: Key) -> String? {
        guard isBackedByEnvironment,
            key.path.count == 1,
            let variable = key.path.first
            else { return nil }
        return environment[variable]
    }

    /// Updates `value` for the given `key`
    func set(value: String?, for key: Key) {
        data[key] = value
    }

    /// Returns value associated with the given `key`
    public subscript(_ key: Key) -> String? {
        get { value(for: key) }
        set { set(value: newValue, for: key) }
    }

    /// Returns value associated with the given `key`
    public subscript<Value>(_ key: Key) -> Value? where Value: LosslessStringConvertible {
        get { value(for: key).flatMap(Value.init) }
        set { set(value: newValue?.description, for: key) }
    }

    /// Returns value associated with the given `key` or throws an error
    /// - Throws: `ConfigurationError.missing`
    public func require(_ key: Key) throws -> String {
        guard let value = self[key]
            else { throw ConfigurationError.missing(key: key) }
        return value
    }

    /// Returns value associated with the given `key` or throws an error
    /// - Throws: `ConfigurationError.missing`
    public func require<Value>(_ key: Key) throws -> Value where Value: LosslessStringConvertible {
        guard let value = self[key] as Value?
            else { throw ConfigurationError.missing(key: key) }
        return value
    }

    /// Returns all stored values
    public func dump() -> [Key: String] {
        data
    }

    /// Loads values from the given source
    /// - Parameter provider: provide values
    /// - Throws: `ConfigurationError`
    public func load(from provider: ConfigurationProvider) throws {
        try data.merge(provider.configuration(),
                       uniquingKeysWith: { _, new in new })
    }
}
