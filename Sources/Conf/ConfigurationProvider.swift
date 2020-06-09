import Foundation

public protocol ConfigurationProvider {
    func configuration() throws -> [Key: String]
}

final class CommonConfigurationProvider: ConfigurationProvider {
    typealias Fetcher = () throws -> Data
    typealias Parser = (Data) throws -> [String: Any]

    init(loader: @escaping Fetcher, parser: @escaping Parser) {
        self.load = loader
        self.parse = parser
    }

    let load: Fetcher
    let parse: Parser

    func configuration() throws -> [Key: String] {
        let rawData: Data
        let parsedData: [String: Any]
        do {
            try rawData = load()
        } catch { throw ConfigurationError.fetch(error) }
        do {
            parsedData = try parse(rawData)
        } catch { throw ConfigurationError.parse(error) }
        return try decode(currentKey: Key(), object: parsedData)
    }

    func decode(currentKey: Key, object: Any) throws -> [Key: String] {
        switch object {
        case let value as LosslessStringConvertible:
            return [currentKey: value.description]
        case let value as [String: LosslessStringConvertible]:
            return .init(uniqueKeysWithValues:
                value.map { key, value in
                    (currentKey.child(key: key), value.description) })
        case let dictionary as [String: Any]:
            return try dictionary.map { key, value in
                try decode(currentKey: currentKey.child(key: key), object: value)
            }.reduce(into: [Key: String]()) { result, value in
                result.merge(value) { current, _ in current }
            }
        case let array as [LosslessStringConvertible]:
            return .init(uniqueKeysWithValues:
                array.enumerated()
                    .map { ( currentKey.child(key: String($0)), $1.description) })
        default:
            throw ConfigurationError.decode(path: currentKey, value: object)
        }
    }
}
