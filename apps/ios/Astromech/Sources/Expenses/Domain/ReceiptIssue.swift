import Foundation

enum ReceiptIssue: Hashable, Sendable {
    case missing(ReceiptField)
    case unrecognizedRNC
    case unrecognizedNCF
    case amountsDoNotAddUp(expectedTotal: Decimal)

    var field: ReceiptField {
        switch self {
        case .missing(let field): field
        case .unrecognizedRNC: .rnc
        case .unrecognizedNCF: .ncf
        case .amountsDoNotAddUp: .total
        }
    }
}
