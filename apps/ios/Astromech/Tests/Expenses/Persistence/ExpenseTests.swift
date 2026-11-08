import Foundation
import SwiftData
import Testing
@testable import Astromech

@MainActor
struct ExpenseTests {
    let container: ModelContainer

    init() throws {
        container = try ModelContainer(
            for: Expense.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    static let draft = ReceiptDraft(
        businessName: "Supermercado Nacional",
        rncText: "101010632",
        ncfText: "B0100000123",
        invoiceDate: Date(timeIntervalSince1970: 1_790_000_000),
        amounts: ReceiptAmounts(subtotal: .exactly("1000.50"), itbis: .exactly("180.09"), propina: 100, total: .exactly("1280.59")),
        scanImage: Data((0..<200_000).map { UInt8(truncatingIfNeeded: $0) })
    )

    func save(_ expense: Expense) throws {
        let context = ModelContext(container)
        context.insert(expense)
        try context.save()
    }

    func fetchFromAFreshContext() throws -> [Expense] {
        try ModelContext(container).fetch(FetchDescriptor<Expense>())
    }

    @Test func persistsEveryDraftFieldIncludingTheScanImage() throws {
        try save(Expense(draft: Self.draft))

        let stored = try #require(try fetchFromAFreshContext().first)
        #expect(stored.draft == Self.draft)
    }

    @Test func assigningAnEditedDraftReplacesTheStoredFields() throws {
        let context = ModelContext(container)
        let expense = Expense(draft: Self.draft)
        context.insert(expense)

        var edited = Self.draft
        edited.businessName = "La Sirena"
        edited.amounts.propina = nil
        edited.invoiceDate = nil
        edited.scanImage = nil
        expense.draft = edited
        try context.save()

        let stored = try #require(try fetchFromAFreshContext().first)
        #expect(stored.draft == edited)
    }

    @Test func assigningAnUnchangedDraftLeavesTheRecordClean() throws {
        let context = ModelContext(container)
        let expense = Expense(draft: Self.draft)
        context.insert(expense)
        try context.save()

        expense.draft = expense.draft

        #expect(!context.hasChanges)
    }

    @Test func reportsTheSameIssuesAsItsDraft() {
        var draft = Self.draft
        draft.rncText = "123"
        draft.amounts.total = nil

        #expect(Expense(draft: draft).issues == [.unrecognizedRNC, .missing(.total)])
    }
}
