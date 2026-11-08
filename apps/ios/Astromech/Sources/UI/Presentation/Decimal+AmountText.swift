import Foundation

extension Decimal {
    private static let currencyPrefixes = ["RD$", "DOP", "$"]

    init?(amountText text: String) {
        let unprefixed = Self.currencyPrefixes.reduce(text.trimmed.uppercased()) { remainder, prefix in
            remainder.hasPrefix(prefix) ? String(remainder.dropFirst(prefix.count)) : remainder
        }
        let kept = unprefixed.filter { !$0.isWhitespace }
        guard kept.allSatisfy({ $0.isASCIIDigit || $0 == "." || $0 == "," }),
              kept.contains(where: \.isASCIIDigit)
        else { return nil }

        let decimalSeparatorIndex = kept.lastIndex(where: { $0 == "." || $0 == "," }).flatMap { index in
            kept.distance(from: index, to: kept.endIndex) - 1 <= 2 ? index : nil
        }
        let integerPart = kept[..<(decimalSeparatorIndex ?? kept.endIndex)].filter(\.isASCIIDigit)
        let fractionPart = decimalSeparatorIndex.map { kept[kept.index(after: $0)...] } ?? ""
        guard fractionPart.allSatisfy(\.isASCIIDigit) else { return nil }

        self.init(string: "\(integerPart.isEmpty ? "0" : integerPart).\(fractionPart.isEmpty ? "0" : fractionPart)", locale: Locale(identifier: "en_US_POSIX"))
    }

    var amountText: String {
        formatted(.number.locale(Locale(identifier: "en_US")).precision(.fractionLength(2)))
    }

    var currencyText: String {
        formatted(.currency(code: "DOP").locale(Locale(identifier: "es_DO")))
    }
}

extension Decimal? {
    func isDisplayed(as text: String) -> Bool {
        (self?.amountText ?? "") == text
    }
}
