import Foundation

struct RNC: Hashable, Sendable {
    enum Kind: Sendable {
        case company
        case individual
    }

    let digits: String
    let kind: Kind

    init?(_ text: String) {
        let digits = text.removingDocumentSeparators
        guard digits.allSatisfy(\.isASCIIDigit) else { return nil }

        switch digits.count {
        case 9 where Self.hasValidCompanyCheckDigit(digits):
            kind = .company
        case 11 where Self.hasValidCedulaCheckDigit(digits):
            kind = .individual
        default:
            return nil
        }
        self.digits = digits
    }

    var formatted: String {
        switch kind {
        case .company: digits.grouped(by: [1, 2, 5, 1])
        case .individual: digits.grouped(by: [3, 7, 1])
        }
    }

    private static func hasValidCompanyCheckDigit(_ digits: String) -> Bool {
        let values = digits.compactMap(\.wholeNumberValue)
        let weights = [7, 9, 8, 6, 5, 4, 3, 2]
        let weightedSum = zip(values, weights).map(*).reduce(0, +)
        let expectedCheckDigit = (10 - weightedSum % 11) % 9 + 1
        return values.last == expectedCheckDigit
    }

    private static func hasValidCedulaCheckDigit(_ digits: String) -> Bool {
        let luhnSum = digits.compactMap(\.wholeNumberValue).reversed().enumerated().map { position, value in
            guard position.isMultiple(of: 2) == false else { return value }
            let doubled = value * 2
            return doubled > 9 ? doubled - 9 : doubled
        }.reduce(0, +)
        return luhnSum.isMultiple(of: 10)
    }
}
