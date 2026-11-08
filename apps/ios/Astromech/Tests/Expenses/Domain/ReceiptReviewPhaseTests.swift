import Foundation
import Testing
@testable import Astromech

struct ReceiptReviewPhaseTests {
    static let incomplete = ReceiptDraft(businessName: "La Sirena")
    static let complete = ReceiptDraft(
        businessName: "La Sirena",
        rncText: "101010632",
        ncfText: "B0100000123",
        invoiceDate: Date(timeIntervalSince1970: 1_790_000_000),
        amounts: ReceiptAmounts(subtotal: 1000, itbis: 180, total: 1180)
    )

    @Test func cannotSaveWhileReading() {
        var phase = ReceiptReviewPhase.reading
        let saved = phase.requestSave(of: Self.complete)
        #expect(!saved)
        #expect(phase == .reading)
    }

    @Test func savesAnIncompleteReceiptTheModelReadBecauseItsGapsAreAlreadyFlagged() {
        var phase = ReceiptReviewPhase.reviewing(readFailure: nil)
        #expect(phase.missingFields == .flagged)
        let saved = phase.requestSave(of: Self.incomplete)
        #expect(saved)
    }

    @Test func holdsTheFirstSaveOfAnIncompleteManualEntryToRevealWhatIsMissing() {
        var phase = ReceiptReviewPhase.reviewing(readFailure: .noTextFound)
        #expect(phase.missingFields == .deferred)

        let saved = phase.requestSave(of: Self.incomplete)
        #expect(!saved)

        #expect(phase == .confirmingIncomplete(readFailure: .noTextFound))
        #expect(phase.missingFields == .flagged)
    }

    @Test func theSecondSaveKeepsTheIncompleteManualEntry() {
        var phase = ReceiptReviewPhase.confirmingIncomplete(readFailure: .noTextFound)
        let saved = phase.requestSave(of: Self.incomplete)
        #expect(saved)
    }

    @Test func aCompleteManualEntrySavesOnTheFirstTap() {
        var phase = ReceiptReviewPhase.reviewing(readFailure: .noTextFound)
        let saved = phase.requestSave(of: Self.complete)
        #expect(saved)
    }

    @Test func dropsTheSaveAnywayOfferOnceNothingIsMissing() {
        var phase = ReceiptReviewPhase.confirmingIncomplete(readFailure: .noTextFound)
        phase.draftDidChange(to: Self.complete)
        #expect(phase == .reviewing(readFailure: .noTextFound))
    }

    @Test func keepsTheSaveAnywayOfferWhileFieldsAreStillMissing() {
        var phase = ReceiptReviewPhase.confirmingIncomplete(readFailure: .noTextFound)
        phase.draftDidChange(to: Self.incomplete)
        #expect(phase == .confirmingIncomplete(readFailure: .noTextFound))
    }
}
