import Foundation

extension Config {

    /// Loads values from the given source
    /// - Parameters:
    ///   - source: method of data acquiring
    ///   - format: data format
    /// - Throws: `ConfigurationError`
    public func load(_ source: Source, format: Format = .dotEnv) throws {
        try load(from: DefaultConfigurationProvider(loader: source.fetcher, parser: format.parser))
    }

    /// External data source
    public enum Source {
        case data(Data)
        case url(URL)
        case file(name: String)
        case string(String)

        var fetcher: FetcherType {
            switch self {
            case let .data(value): return Fetcher.direct(value)
            case let .url(value): return Fetcher.url(value)
            case let .file(value): return Fetcher.file(value)
            case let .string(value): return Fetcher.string(value)
            }
        }
    }

    /// External data format
    public enum Format {
        case dotEnv
        case json
        case plist
        case custom(ParserType)

        var parser: ParserType {
            switch self {
            case .dotEnv: return Parser.donEnv
            case .json: return Parser.json
            case .plist: return Parser.plist
            case .custom(let parser): return parser
            }
        }
    }

}
