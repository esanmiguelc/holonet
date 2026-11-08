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

    func visibleIssues(missingFields: MissingFieldVisibility) -> [ReceiptIssue] {
        switch missingFields {
        case .flagged: issues
        case .deferred: issues.filter { !$0.isMissingField }
        }
    }

    func issues(for field: ReceiptField, missingFields: MissingFieldVisibility = .flagged) -> [ReceiptIssue] {
        visibleIssues(missingFields: missingFields).filter { $0.field == field }
    }

    func fieldsNeedingAttention(missingFields: MissingFieldVisibility = .flagged) -> Int {
        Set(visibleIssues(missingFields: missingFields).map(\.field)).count
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
