import Foundation
import Testing
@testable import Astromech

struct ExpenseDateSummaryTests {
    static let scannedAt = Date(timeIntervalSince1970: 1_790_000_000)
    static let invoicedAt = Date(timeIntervalSince1970: 1_780_000_000)

    @Test func showsTheInvoiceDateWhenThereIsOne() {
        let expense = Expense(draft: ReceiptDraft(invoiceDate: Self.invoicedAt), createdAt: Self.scannedAt)
        #expect(expense.dateSummary == Self.invoicedAt.formatted(date: .abbreviated, time: .omitted))
    }

    @Test func labelsTheScanDateAsSuchWhenThereIsNoInvoiceDate() {
        let expense = Expense(draft: ReceiptDraft(), createdAt: Self.scannedAt)
        #expect(expense.dateSummary == "Scanned \(Self.scannedAt.formatted(date: .abbreviated, time: .omitted))")
    }
}
