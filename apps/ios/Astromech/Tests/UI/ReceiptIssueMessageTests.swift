import Foundation
import Testing
@testable import Astromech

struct ReceiptIssueMessageTests {
    @Test func namesTheMissingField() {
        #expect(ReceiptIssue.missing(.propina).message == "Propina legal is missing")
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
