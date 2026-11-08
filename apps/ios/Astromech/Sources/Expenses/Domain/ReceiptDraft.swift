import Foundation

struct ReceiptDraft: Equatable, Sendable {
    var businessName = ""
    var rncText = ""
    var ncfText = ""
    var invoiceDate: Date?
    var amounts = ReceiptAmounts()
    var scanImage: Data?

    var rnc: RNC? { RNC(rncText) }
    var ncf: NCF? { NCF(ncfText) }
    var isEmpty: Bool { self == ReceiptDraft() }

    var issues: [ReceiptIssue] {
        [
            businessName.isBlank ? .missing(.businessName) : nil,
            documentIssue(text: rncText, field: .rnc, isRecognized: rnc != nil, unrecognized: .unrecognizedRNC),
            documentIssue(text: ncfText, field: .ncf, isRecognized: ncf != nil, unrecognized: .unrecognizedNCF),
            invoiceDate == nil ? .missing(.invoiceDate) : nil,
            amounts.subtotal == nil ? .missing(.subtotal) : nil,
            amounts.itbis == nil ? .missing(.itbis) : nil,
            amounts.total == nil ? .missing(.total) : nil,
            amounts.reconciliationIssue,
        ].compactMap(\.self)
    }

    func issues(for field: ReceiptField) -> [ReceiptIssue] {
        issues.filter { $0.field == field }
    }

    private func documentIssue(
        text: String,
        field: ReceiptField,
        isRecognized: Bool,
        unrecognized: ReceiptIssue
    ) -> ReceiptIssue? {
        if text.isBlank { return .missing(field) }
        return isRecognized ? nil : unrecognized
    }
}
