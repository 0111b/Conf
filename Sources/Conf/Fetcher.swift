import Foundation

public typealias FetcherType = () throws -> Data

/// Namespace for the predefined fetchers
enum Fetcher { }

extension Fetcher {

    static let direct: (Data) -> FetcherType = { data in
       return { data }
    }

    static let url: (URL) -> FetcherType = { url in
        return { try Data(contentsOf: url) }
    }

    static let file: (String) -> FetcherType = { configName in
        return url(URL(fileURLWithPath: configName, isDirectory: false))
    }

    static let string: (String) -> FetcherType = { string in
        return {
            guard let data = string.data(using: .utf8) else {
                struct InvalidString: Error {}
                throw InvalidString()
            }
            return data
        }
    }

}
