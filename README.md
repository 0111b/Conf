# Conf
[![Build Status](http://ci.merlin.local/api/badges/adan/Conf/status.svg)](http://ci.merlin.local/adan/Conf)
[![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)](https://developer.apple.com/swift/)

Config made easy

## Summary

This package provide easy way to work with configs. Mostly usefull in CLI-tools. Extentable and customisable.

## Typical usecases

For more details please refer the tests

### Creating the config
```swift
let config = Config(useEnvironment: true)
```

### Load configurations

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

### Data representation
All values are stored as `Key`-`String` pairs. There are convenience methods to use `LosslessStringConvertible`. 
The `Key`  represents the value position in the provided source. For basic key-value formats it is just a string. For nested types it is the array of strings. Arrays values are mapped as multiple values:
```
Key<arrayName, 0> = <first element>
Key<arrayName, 1> = <second element>
...
Key<arrayName, count-1> = <last element>
```

### Reading the value
Values can be accessed via subscripts

```swift
let path: String? = config["PATH"]

let port: Int? = config["HTTP_PORT"]

let key = Key("myKey")
let value = config[key]

let value = config[["key", "nested"]]

let value = config[["array", 2]]
```

### Require the value

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
### Updating values
Values can be updated via subscript
```swift
config["foo"] = "bar"
config["answer"] = 42
```

### Creating the keys
```swift
let key: Key = "24"
let key: Key = 99
let key4: Key = Key(23.4)
let key5: Key = Key("some")
let key6: Key = ["24", 72, 23.4, true]
let key7: Key = Key([1, 2, 3])
```


### Working with process environment
Env values can be assessed separately with `Environment`
```swift
let env = Environment()
let home = env["HOME"]
let path = env.PATH
env.TMPDIR = "/tmp"
```

# Customisation

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

It is also possbile to provide completelly custom implementation of the data fetching behaviour. To do this you need to adopt `ConfigurationProvider`

```swift
struct CustomConfigurationProvider: ConfigurationProvider {
    func configuration() throws -> [Key : String] {
        return ["key": "value]
    }
}
config.load(from: CustomConfigurationProvider())
```

# TODO

[-] Cocoapods support
[-] Carthage support
