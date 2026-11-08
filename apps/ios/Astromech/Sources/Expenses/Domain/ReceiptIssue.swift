import Foundation

enum MissingFieldVisibility: Sendable {
    case flagged
    case deferred
}

enum ReceiptIssue: Hashable, Sendable {
    case missing(ReceiptField)
    case unrecognizedRNC
    case unrecognizedNCF
    case amountsDoNotAddUp(expectedTotal: Decimal)

    var isMissingField: Bool {
        if case .missing = self { true } else { false }
    }

    var field: ReceiptField {
        switch self {
        case .missing(let field): field
        case .unrecognizedRNC: .rnc
        case .unrecognizedNCF: .ncf
        case .amountsDoNotAddUp: .total
        }
    }
}
