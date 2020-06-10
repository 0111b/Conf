import Foundation

/// Namespace for the predefined fetchers
enum Fetcher { }

extension Fetcher {

    static let direct: (Data) -> DefaultConfigurationProvider.Fetcher = { data in
       return { data }
    }

    static let file: (String) -> DefaultConfigurationProvider.Fetcher = { configName in
        return {
            let url = URL(fileURLWithPath: configName, isDirectory: false)
            print(url)
            return try Data(contentsOf: url)
        }
    }
}
