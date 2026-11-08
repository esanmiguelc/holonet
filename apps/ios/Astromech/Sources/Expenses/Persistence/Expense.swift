import Foundation
import SwiftData

@Model
final class Expense {
    var businessName = ""
    var rncText = ""
    var ncfText = ""
    var invoiceDate: Date?
    var subtotal: Decimal?
    var itbis: Decimal?
    var propina: Decimal?
    var total: Decimal?
    @Attribute(.externalStorage) var scanImage: Data?
    var createdAt: Date

    init(draft: ReceiptDraft, createdAt: Date = .now) {
        self.createdAt = createdAt
        self.draft = draft
    }

    var draft: ReceiptDraft {
        get {
            var draft = draftWithoutScan
            draft.scanImage = scanImage
            return draft
        }
        set {
            assignIfChanged(\.businessName, newValue.businessName)
            assignIfChanged(\.rncText, newValue.rncText)
            assignIfChanged(\.ncfText, newValue.ncfText)
            assignIfChanged(\.invoiceDate, newValue.invoiceDate)
            assignIfChanged(\.subtotal, newValue.amounts.subtotal)
            assignIfChanged(\.itbis, newValue.amounts.itbis)
            assignIfChanged(\.propina, newValue.amounts.propina)
            assignIfChanged(\.total, newValue.amounts.total)
            assignIfChanged(\.scanImage, newValue.scanImage)
        }
    }

    var issues: [ReceiptIssue] { draftWithoutScan.issues }

    private func assignIfChanged<Value: Equatable>(_ keyPath: ReferenceWritableKeyPath<Expense, Value>, _ value: Value) {
        if self[keyPath: keyPath] != value {
            self[keyPath: keyPath] = value
        }
    }

    private var draftWithoutScan: ReceiptDraft {
        ReceiptDraft(
            businessName: businessName,
            rncText: rncText,
            ncfText: ncfText,
            invoiceDate: invoiceDate,
            amounts: ReceiptAmounts(subtotal: subtotal, itbis: itbis, propina: propina, total: total)
        )
    }
}
