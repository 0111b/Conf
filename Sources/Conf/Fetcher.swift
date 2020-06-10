import Foundation

/// Namespace for the predefined fetchers
enum Fetcher { }

extension Fetcher {

    static let direct: (Data) -> DefaultConfigurationProvider.Fetcher = { data in
       return { data }
    }

    static let url: (URL) -> DefaultConfigurationProvider.Fetcher = { url in
        return { try Data(contentsOf: url) }
    }

    static let file: (String) -> DefaultConfigurationProvider.Fetcher = { configName in
        return url(URL(fileURLWithPath: configName, isDirectory: false))
    }

    static let string: (String) -> DefaultConfigurationProvider.Fetcher = { string in
        return {
            guard let data = string.data(using: .utf8) else {
                struct InvalidString: Error {}
                throw InvalidString()
            }
            return data
        }
    }

}
