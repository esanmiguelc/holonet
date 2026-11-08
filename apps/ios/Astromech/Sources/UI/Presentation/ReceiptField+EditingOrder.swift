extension ReceiptField {
    static let editingOrder: [ReceiptField] = [.businessName, .rnc, .ncf, .subtotal, .itbis, .propina, .total]

    var nextInEditingOrder: ReceiptField? {
        guard let index = Self.editingOrder.firstIndex(of: self) else { return nil }
        return Self.editingOrder.dropFirst(index + 1).first
    }
}
