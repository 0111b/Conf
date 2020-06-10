import Foundation

/// Namespace for the predefined fetchers
enum Fetcher { }

extension Fetcher {

    static let direct: (Data) -> CommonConfigurationProvider.Fetcher = { data in
       return { data }
    }

    static let file: (String) -> CommonConfigurationProvider.Fetcher = { configName in
        return {
            let url = URL(fileURLWithPath: configName, isDirectory: false)
            print(url)
            return try Data(contentsOf: url)
        }
    }
}
