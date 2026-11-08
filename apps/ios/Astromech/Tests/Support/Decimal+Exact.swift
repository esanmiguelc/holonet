import Foundation

extension Decimal {
    static func exactly(_ text: String) -> Decimal {
        guard let value = Decimal(string: text, locale: Locale(identifier: "en_US_POSIX")) else {
            preconditionFailure("Invalid decimal fixture: \(text)")
        }
        return value
    }
}
