import Foundation

extension ReceiptDraft {
    init(decoding extraction: ReceiptExtraction, scanImage: Data?, calendar: Calendar = .current) {
        self.init(
            businessName: extraction.businessName?.trimmed ?? "",
            rncText: Self.normalizedDocumentText(extraction.rnc, validatedAs: { RNC($0)?.digits }),
            ncfText: Self.normalizedDocumentText(extraction.ncf, validatedAs: { NCF($0)?.code }),
            invoiceDate: extraction.invoiceDate.flatMap { Self.calendarDay(fromPrinted: $0, in: calendar) },
            amounts: ReceiptAmounts(
                subtotal: extraction.subtotal,
                itbis: extraction.itbis,
                propina: extraction.propina,
                total: extraction.total
            ),
            scanImage: scanImage
        )
    }

    private static func normalizedDocumentText(_ text: String?, validatedAs canonical: (String) -> String?) -> String {
        guard let text = text?.trimmed else { return "" }
        return canonical(text) ?? text
    }

    private static func calendarDay(fromPrinted text: String, in calendar: Calendar) -> Date? {
        let printedDay = text.split(whereSeparator: \.isWhitespace).first ?? ""
        let parts = printedDay.split(whereSeparator: { "/-.".contains($0) })
        let numbers = parts.compactMap { part in
            (1...4).contains(part.count) && part.allSatisfy(\.isASCIIDigit) ? Int(part) : nil
        }
        guard parts.count == 3, numbers.count == 3 else { return nil }

        let isYearFirst = parts[0].count == 4
        let (year, month, day) = isYearFirst
            ? (numbers[0], numbers[1], numbers[2])
            : (numbers[2], numbers[1], numbers[0])

        let components = DateComponents(year: year < 100 ? 2000 + year : year, month: month, day: day)
        guard components.isValidDate(in: calendar) else { return nil }
        return calendar.date(from: components)?.anchoredToNoon(in: calendar)
    }
}
