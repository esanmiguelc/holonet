extension ReceiptDraft {
    func attentionMessage(missingFields: MissingFieldVisibility) -> String? {
        switch fieldsNeedingAttention(missingFields: missingFields) {
        case 0: nil
        case 1: "1 field needs attention"
        case let count: "\(count) fields need attention"
        }
    }
}
