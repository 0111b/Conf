import Foundation

/// Namespace for the predefined parsers
enum Parser {
    static let json: CommonConfigurationProvider.Parser = { data in
        let object: Any
        do {
            object = try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            throw ConfigurationError.parse(error)
        }
        guard let values = object as? [String: Any] else {
            struct InvalidJsonFormat: Error { let data: Data }
            throw ConfigurationError.parse(InvalidJsonFormat(data: data))
        }
        return values
    }
}
