import Foundation
import Testing
@testable import Astromech

struct ReceiptDraftExtractionTests {
    static let santoDomingo: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Santo_Domingo")!
        return calendar
    }()

    static func decode(_ extraction: ReceiptExtraction, scanImage: Data? = nil) -> ReceiptDraft {
        ReceiptDraft(decoding: extraction, scanImage: scanImage, calendar: santoDomingo)
    }

    @Test func decodesEveryExtractedField() {
        let image = Data([0xFF, 0xD8])
        let draft = Self.decode(
            ReceiptExtraction(
                businessName: "  Supermercado Nacional ",
                rnc: "1-01-01063-2",
                ncf: "b01 00000123",
                invoiceDate: "07/11/2026",
                subtotal: 1000,
                itbis: 180,
                propina: 100,
                total: 1280
            ),
            scanImage: image
        )

        #expect(draft.businessName == "Supermercado Nacional")
        #expect(draft.rncText == "1-01-01063-2")
        #expect(draft.rnc?.digits == "101010632")
        #expect(draft.ncfText == "B0100000123")
        #expect(draft.invoiceDate == Self.santoDomingo.date(from: DateComponents(year: 2026, month: 11, day: 7, hour: 12)))
        #expect(draft.amounts == ReceiptAmounts(subtotal: 1000, itbis: 180, propina: 100, total: 1280))
        #expect(draft.scanImage == image)
        #expect(draft.issues.isEmpty)
    }

    @Test func keepsUnvalidatedDocumentNumbersAsReadSoTheReviewerCanFixThem() {
        let draft = Self.decode(ReceiptExtraction(rnc: " 1O1010632 ", ncf: "B01-0000"))

        #expect(draft.rncText == "1O1010632")
        #expect(draft.ncfText == "B01-0000")
        #expect(draft.issues(for: .rnc) == [.unrecognizedRNC])
        #expect(draft.issues(for: .ncf) == [.unrecognizedNCF])
    }

    @Test(arguments: ["07/11/2026", "7/11/2026", "07-11-2026", "07.11.26", "2026-11-07", "07/11/2026 10:45", " 07/11/2026 14:02:11 "])
    func readsDayFirstDominicanDatesAndISODates(text: String) {
        let expected = Self.santoDomingo.date(from: DateComponents(year: 2026, month: 11, day: 7, hour: 12))
        #expect(Self.decode(ReceiptExtraction(invoiceDate: text)).invoiceDate == expected)
    }

    @Test(arguments: ["30/02/2026", "11/31/2026", "2026-11", "15/03/99999999999999999999", "07/11/20266", "ayer", ""])
    func leavesTheDateEmptyWhenItIsNotAValidCalendarDay(text: String) {
        #expect(Self.decode(ReceiptExtraction(invoiceDate: text)).invoiceDate == nil)
    }

    @Test func aPrintedDateStaysOnTheSameDayInANearbyTimeZone() throws {
        var mexicoCity = Calendar(identifier: .gregorian)
        mexicoCity.timeZone = try #require(TimeZone(identifier: "America/Mexico_City"))

        let date = try #require(Self.decode(ReceiptExtraction(invoiceDate: "07/11/2026")).invoiceDate)

        #expect(mexicoCity.component(.day, from: date) == 7)
    }

    @Test func anEmptyExtractionDecodesToAnEmptyDraft() {
        #expect(Self.decode(ReceiptExtraction()) == ReceiptDraft())
    }
}
