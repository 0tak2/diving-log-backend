import Vapor

final class CustomLoggerProvider {
    static func of(_ label: String) -> Logger {
        Logger(label: label)
    }
}
