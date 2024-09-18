import Foundation

/// Raw data acquiring type
public typealias FetcherType = @Sendable () throws -> Data

/// Namespace for the predefined fetchers
enum Fetcher { }

extension Fetcher {

    static let direct: @Sendable (Data) -> FetcherType = { data in
       return { data }
    }

    static let url: @Sendable (URL) -> FetcherType = { url in
        return { try Data(contentsOf: url) }
    }

    static let file: @Sendable (String) -> FetcherType = { configName in
        return url(URL(fileURLWithPath: configName, isDirectory: false))
    }

    static let string: @Sendable (String) -> FetcherType = { string in
        return {
            guard let data = string.data(using: .utf8) else {
                struct InvalidString: Error {}
                throw InvalidString()
            }
            return data
        }
    }

}
