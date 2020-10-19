# Conf

Config made easy

![CI](https://github.com/0111b/Conf/workflows/CI/badge.svg)
![Tag](https://img.shields.io/github/v/tag/0111b/Conf)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0111b%2FConf%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0111b/Conf)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0111b%2FConf%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0111b/Conf)

This package provide easy way to work with configs. Mostly usefull in CLI-tools. Extentable and customisable.

## Contents ##

* [Usage](#usage)
    * [Creating the config](#creating-the-config)
    * [Load configurations](#load-configurations)
    * [Data representation](#data-representation)
    * [Reading the value](#reading-the-value)
    * [Require the value](#require-the-value)
    * [Updating values](#updating-values)
    * [Creating the keys](#creating-the-keys)
    * [Working with process environment](#working-with-process-environment)
* [Customisation](#customisation)
    * [Adding data format](#adding-data-format)
    * [Custom parsing](#custom-parsing)
* [TODO](#todo)

## Usage ##

For more details please refer the tests

### Creating the config ###

```swift
let config = Config(useEnvironment: true)
```

### Load configurations ###

```swift
try config.load(.file(name: ".env.dev"))
// or
let url = Bundle.main.url(forResource: "myConfig", withExtension: "plist")!
try config.load(.url(url), format: .plist)
// or
let json = """
{"key": "value"}
"""
try config.load(.string(json), format: .json)
```

### Data representation ###

All values are stored as `Key`-`String` pairs. There are convenience methods to use `LosslessStringConvertible`.

The `Key`  represents the value position in the provided source.

For basic key-value formats it is just a string.

For nested types key is the array of strings.

Arrays are mapped as multiple key-value pairs:

```
Key<arrayName, 0> = <first element>
Key<arrayName, 1> = <second element>
...
Key<arrayName, count-1> = <last element>
```

### Reading the value ###

Values can be accessed via subscripts

```swift
let path: String? = config["PATH"]

let port: Int? = config["HTTP_PORT"]

let key = Key("myKey")
let value = config[key]

let value = config[["key", "nested"]]

let value = config[["array", 2]]

extension Key {
    static let clientId = Key("SECRET_CLIENT_ID")
}

let value = config[.clientId]
```

### Require the value ###

For required values you can use `require` method which throws `ConfigurationError.missing(key:)` if value is not found.

```swift
let requiredValue = try config.require("secret")

struct MyCredentials {
    let username: String
    let password: String
}

extension Config {
    func credentials() throws -> MyCredentials {
        try MyCredentials(username: require("username"),
                          password: require("password"))
    }
}
```

### Updating values ###

Values can be updated via subscript

```swift
config["foo"] = "bar"
config["answer"] = 42
```

### Creating the keys ###

```swift
let key: Key = "myKey"
let key: Key = 99
let key: Key = Key(23.4)
let key: Key = Key("some")
let key: Key = ["24", 72, 23.4, true]
let key: Key = Key([1, 2, 3])
```

### Working with process environment ###

`Conf` can fallback to the environment variables. This is controlled by `useEnvironment` variable in the constructor.

Env values can be assessed separately with `Environment`

```swift
let env = Environment()
let home = env["HOME"]
let path = env.PATH
env.TMPDIR = "/tmp"
```

## Customisation ##

### Adding data format ###

If you want to add support for different config format  you just need to implement your own parser function and call `load` with `Format.custom`.

For example here is how `yaml` support can be added with [Yams](https://github.com/jpsim/Yams)

```swift
let yamlParser: ParserType = { data in
    guard let rawYaml = String(data: data, encoding: .utf8),
        let values = try Yams.load(yaml: rawYaml) as? [String: Any]
        else {
            struct InvalidYaml: Error {}
            throw InvalidYaml()
    }
    return values
}

try config.load(.file(name: "config.yml"), format: .custom(yamlParser))
```

### Custom parsing ###

It is also possbile to provide completelly custom implementation of the data fetching behaviour. To do this you need to adopt `ConfigurationProvider`

```swift
struct CustomConfigurationProvider: ConfigurationProvider {
    func configuration() throws -> [Key : String] {
        return ["key": "value"]
    }
}
config.load(from: CustomConfigurationProvider())
```

## TODO ##

- [ ] Cocoapods support
- [ ] Carthage support
- [x] Github mirror
