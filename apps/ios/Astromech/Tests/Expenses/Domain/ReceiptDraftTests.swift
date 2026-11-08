import Foundation
import Testing
@testable import Astromech

struct ReceiptDraftTests {
    static let complete = ReceiptDraft(
        businessName: "Supermercado Nacional",
        rncText: "101010632",
        ncfText: "B0100000123",
        invoiceDate: Date(timeIntervalSince1970: 1_790_000_000),
        amounts: ReceiptAmounts(subtotal: 1000, itbis: 180, total: 1180)
    )

    @Test func aCompleteReceiptHasNoIssues() {
        #expect(Self.complete.issues.isEmpty)
    }

    @Test func anEmptyDraftIsMissingEveryRequiredField() {
        #expect(ReceiptDraft().issues == [
            .missing(.businessName),
            .missing(.rnc),
            .missing(.ncf),
            .missing(.invoiceDate),
            .missing(.subtotal),
            .missing(.itbis),
            .missing(.total),
        ])
    }

    @Test func propinaIsOptional() {
        #expect(Self.complete.issues(for: .propina).isEmpty)
    }

    @Test func whitespaceOnlyBusinessNameCountsAsMissing() {
        var draft = Self.complete
        draft.businessName = "   "
        #expect(draft.issues == [.missing(.businessName)])
    }

    @Test func flagsAnRNCThatFailsValidation() {
        var draft = Self.complete
        draft.rncText = "101010633"
        #expect(draft.issues(for: .rnc) == [.unrecognizedRNC])
        #expect(draft.rnc == nil)
    }

    @Test func flagsAnNCFThatFailsValidation() {
        var draft = Self.complete
        draft.ncfText = "B99"
        #expect(draft.issues(for: .ncf) == [.unrecognizedNCF])
    }

    @Test func attachesTheReconciliationIssueToTheTotal() {
        var draft = Self.complete
        draft.amounts.total = 2000
        #expect(draft.issues(for: .total) == [.amountsDoNotAddUp(expectedTotal: 1180)])
    }

    @Test func acceptsACedulaAsTheIssuerRNC() {
        var draft = Self.complete
        draft.rncText = "00113918205"
        #expect(draft.rnc?.kind == .individual)
        #expect(draft.issues.isEmpty)
    }

    @Test func acceptsAnElectronicNCF() {
        var draft = Self.complete
        draft.ncfText = "E310000000123"
        #expect(draft.ncf?.type == .electronicCreditoFiscal)
        #expect(draft.issues.isEmpty)
    }

    @Test func reportsEveryIssueInFormOrder() {
        var draft = Self.complete
        draft.rncText = "123"
        draft.ncfText = ""
        draft.amounts.itbis = nil
        #expect(draft.issues == [.unrecognizedRNC, .missing(.ncf), .missing(.itbis)])
    }

    @Test func deferringMissingFieldsStillReportsInvalidValues() {
        let draft = ReceiptDraft(rncText: "123")
        #expect(draft.visibleIssues(missingFields: .deferred) == [.unrecognizedRNC])
        #expect(draft.issues(for: .total, missingFields: .deferred).isEmpty)
    }

    @Test func countsAFieldOnceHoweverManyIssuesItHas() {
        var draft = Self.complete
        draft.amounts.total = 2000
        draft.rncText = "123"
        #expect(draft.fieldsNeedingAttention() == 2)
    }

    @Test func nothingNeedsAttentionOnACompleteReceipt() {
        #expect(Self.complete.fieldsNeedingAttention() == 0)
    }

    @Test func aDraftWithNothingEnteredAndNoScanIsEmpty() {
        #expect(ReceiptDraft().isEmpty)
    }

    @Test func aDraftHoldingOnlyAScanIsNotEmpty() {
        #expect(!ReceiptDraft(scanImage: Data([0xFF])).isEmpty)
    }
}
