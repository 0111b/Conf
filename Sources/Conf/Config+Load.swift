import Foundation

public extension Config {
    func load(env filename: String) throws {
        try load(from: DefaultConfigurationProvider(loader: Fetcher.file(filename), parser: Parser.donEnv))
    }

    func load(env data: Data) throws {
        try load(from: DefaultConfigurationProvider(loader: Fetcher.direct(data), parser: Parser.donEnv))
    }

    func load(json filename: String) throws {
        try load(from: DefaultConfigurationProvider(loader: Fetcher.file(filename), parser: Parser.json))
    }

    func load(json data: Data) throws {
        try load(from: DefaultConfigurationProvider(loader: Fetcher.direct(data), parser: Parser.json))
    }

    func load(plist filename: String) throws {
        try load(from: DefaultConfigurationProvider(loader: Fetcher.file(filename), parser: Parser.plist))
    }

    func load(plist data: Data) throws {
        try load(from: DefaultConfigurationProvider(loader: Fetcher.direct(data), parser: Parser.plist))
    }

}
