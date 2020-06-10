import Foundation

#if os(macOS)
class MockProcessInfo: ProcessInfo {
    init(_ env: [String: String]) { self.env = env }
    var env: [String: String]
    override var environment: [String: String] { env }
}
#endif

extension ProcessInfo {
    static var instance: ProcessInfo {
        #if os(macOS)
        return ProcessInfo()
        #else
        return ProcessInfo.processInfo
        #endif
    }

    static func make(with env: [String: String]) -> ProcessInfo {
        #if os(macOS)
        return MockProcessInfo(env)
        #else
        let info = ProcessInfo.instance
        info.clearEnv()
        info.set(env: env)
        return info
        #endif
    }

    func clearEnv() {
        environment.forEach {key, _ in
            unsetenv(key)
        }
    }

    func set(env: [String: String]) {
        env.forEach { key, value in
            setenv(key, value, 1)
        }
    }
}
