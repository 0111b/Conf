import Foundation

struct Resource {
    let name: String
    let type: String
    let url: URL

    init(name: String, type: String) {
        self.name = name
        self.type = type
        url = Resource.resourceFolderURL.appendingPathComponent(name).appendingPathExtension(type)
    }
}

// MARK: - Content -
extension Resource {
    func data() throws -> Data { try Data(contentsOf: url) }
    func string() throws -> String { try String(contentsOf: url, encoding: .utf8) }
}

// MARK: - Path helpers -
extension Resource {
    //  expected folder structure
    // <Some folder>
    //  - <Resources>
    //      - <resource files>
    //  - <Some test source folder>
    //      - <test case files>
    //      - <this file>
    static let resourceFolderURL = testsFolderURL
        .deletingLastPathComponent()
        .appendingPathComponent(resourceFolder, isDirectory: true)
        .standardized
    static let testsFolderURL = sourceFileURL.deletingLastPathComponent()
    private static let resourceFolder = "Resources"
    private static let sourceFileURL = URL(fileURLWithPath: #file, isDirectory: false)
}
