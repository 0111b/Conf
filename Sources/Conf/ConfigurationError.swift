public enum ConfigurationError: Error {
    case fetch(Error)
    case parse(Error)
    case decode(path: Key, value: Any)
}
