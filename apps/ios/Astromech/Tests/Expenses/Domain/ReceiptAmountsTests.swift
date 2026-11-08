import Foundation
import Testing
@testable import Astromech

struct ReceiptAmountsTests {
    @Test func reconcilesWhenSubtotalPlusITBISEqualsTotal() {
        let amounts = ReceiptAmounts(subtotal: 1000, itbis: 180, total: 1180)
        #expect(amounts.reconciliationIssue == nil)
    }

    @Test func includesPropinaLegalInTheExpectedTotal() {
        let amounts = ReceiptAmounts(subtotal: 1000, itbis: 180, propina: 100, total: 1280)
        #expect(amounts.reconciliationIssue == nil)
    }

    @Test func toleratesRoundingDifferencesUpToOnePeso() {
        let amounts = ReceiptAmounts(subtotal: .exactly("847.46"), itbis: .exactly("152.54"), total: .exactly("1000.99"))
        #expect(amounts.reconciliationIssue == nil)
    }

    @Test func reportsTheExpectedTotalWhenAmountsDoNotAddUp() {
        let amounts = ReceiptAmounts(subtotal: 1000, itbis: 180, total: 1280)
        #expect(amounts.reconciliationIssue == .amountsDoNotAddUp(expectedTotal: 1180))
    }

    @Test func cannotReconcileUntilSubtotalITBISAndTotalAreKnown() {
        let amounts = ReceiptAmounts(subtotal: 1000, total: 5)
        #expect(amounts.reconciliationIssue == nil)
    }
}
