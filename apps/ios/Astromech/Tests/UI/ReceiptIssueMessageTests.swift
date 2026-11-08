import Foundation
import Testing
@testable import Astromech

struct ReceiptIssueMessageTests {
    let complete = ReceiptAmounts(subtotal: 1000, itbis: 180, total: 1180)

    @Test func namesTheMissingField() {
        #expect(ReceiptIssue.missing(.propina).message == "Propina legal is missing")
    }

    @Test func summarizesOneFieldInTheSingular() {
        #expect(ReceiptDraft(rncText: "123", invoiceDate: .now, amounts: complete).attentionMessage(missingFields: .deferred) == "1 field needs attention")
    }

    @Test func summarizesSeveralFieldsInThePlural() {
        #expect(ReceiptDraft(rncText: "123", ncfText: "B9", invoiceDate: .now, amounts: complete).attentionMessage(missingFields: .deferred) == "2 fields need attention")
    }

    @Test func hasNoSummaryWhenNothingIsVisiblyWrong() {
        #expect(ReceiptDraft().attentionMessage(missingFields: .deferred) == nil)
    }

    @Test func describesEveryNCFSeriesRatherThanOneType() {
        #expect(ReceiptIssue.unrecognizedNCF.message == "Not a valid NCF. Expected B + 10 digits or E + 12 digits.")
    }

    @Test func statesTheTotalTheAmountsActuallyComeTo() {
        let message = ReceiptIssue.amountsDoNotAddUp(expectedTotal: 1180).message
        #expect(message.hasPrefix("Subtotal + ITBIS + propina comes to"))
        #expect(message.hasSuffix(Decimal(1180).currencyText))
    }

    @Test func everyReadingFailureExplainsHowToContinue() {
        let failures: [ReceiptReadingFailure] = [
            .textRecognitionFailed,
            .noTextFound,
            .modelUnavailable(.deviceNotEligible),
            .modelUnavailable(.appleIntelligenceNotEnabled),
            .modelUnavailable(.modelNotReady),
            .modelUnavailable(.unknown),
            .receiptTooLong,
            .unsupportedLanguage,
            .extractionFailed,
        ]
        #expect(failures.allSatisfy { $0.message.contains("below") })
    }
}
