/// Possible module errors
public enum ConfigurationError: Error {
    /// Error during raw data fetching
    case fetch(Error)
    /// Error during parsing raw data to the specified fortmat
    case parse(Error)
    /// Error during transforming data to the internal format
    case decode(path: Key, value: Any)
    /// Missing key requested
    case missing(key: Key)
}
