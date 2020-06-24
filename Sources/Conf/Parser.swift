import Foundation

/// Raw data parser type
public typealias ParserType = (Data) throws -> [String: Any]

/// Namespace for the predefined parsers
enum Parser {
    struct InvalidFormat: Error { let data: Data }
}

extension Parser {
    static let json: ParserType = { data in
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        guard let values = object as? [String: Any] else {
            throw InvalidFormat(data: data)
        }
        return values
    }
}

extension Parser {
    static let donEnv: ParserType = { data in
        func fail() throws -> Never {
            throw InvalidFormat(data: data)
        }
        guard let contents = String(data: data, encoding: .utf8) else { try fail() }
        var result = [String: String]()
        let lines  = contents.split(whereSeparator: { $0 == "\n" || $0 == "\r\n" }).lazy
        for line in lines {
            // ignore comments
            if line.starts(with: "#") { continue }
            // ignore lines that appear empty
            if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                continue
            }
            // extract key and value which are separated by an equals sign
            let parts = line.split(separator: "=", maxSplits: 1)
            guard parts.count == 2 else { try fail() }
            let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            var value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
           // remove surrounding quotes from value & convert remove escape character before any embedded quotes
            if value[value.startIndex] == "\"" && value[value.index(before: value.endIndex)] == "\"" {
                value.remove(at: value.startIndex)
                value.remove(at: value.index(before: value.endIndex))
                value = value.replacingOccurrences(of: "\\\"", with: "\"")
            }
            // remove surrounding single quotes from value & convert remove escape character before any embedded quotes
            if value[value.startIndex] == "'" && value[value.index(before: value.endIndex)] == "'" {
                value.remove(at: value.startIndex)
                value.remove(at: value.index(before: value.endIndex))
                value = value.replacingOccurrences(of: "'", with: "'")
            }
            result[key] = value
        }
        return result

    }
}

extension Parser {
    static let plist: ParserType = { data in
        let object = try PropertyListSerialization.propertyList(from: data, format: nil)
        guard let values = object as? [String: Any] else {
            throw InvalidFormat(data: data)
        }
        return values
    }
}
