enum ConfigurationError: Error {
    case fetch(Error)
    case parse(Error)
    case `import`(path: Key, value: Any)
}
