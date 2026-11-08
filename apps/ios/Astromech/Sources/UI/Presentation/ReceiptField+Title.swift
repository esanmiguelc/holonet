extension ReceiptField {
    var title: String {
        switch self {
        case .businessName: "Business"
        case .rnc: "RNC"
        case .ncf: "NCF"
        case .invoiceDate: "Date"
        case .subtotal: "Subtotal"
        case .itbis: "ITBIS"
        case .propina: "Propina legal"
        case .total: "Total"
        }
    }
}
