extension ReceiptIssue {
    var message: String {
        switch self {
        case .missing(let field): "\(field.title) is missing"
        case .unrecognizedRNC: "Not a valid RNC or cédula. Check the digits."
        case .unrecognizedNCF: "Not a valid NCF. Expected B + 10 digits or E + 12 digits."
        case .amountsDoNotAddUp(let expectedTotal): "Subtotal + ITBIS + propina comes to \(expectedTotal.currencyText)"
        }
    }
}
