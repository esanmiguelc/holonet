import SwiftUI

struct AmountField: View {
    let field: ReceiptField
    let issues: [ReceiptIssue]
    let focus: FocusState<ReceiptField?>.Binding
    @Binding var amount: Decimal?
    @State private var text = ""

    var body: some View {
        FormTextField(
            field: field,
            label: field.title,
            prompt: "0.00",
            input: .amount,
            issues: issues,
            focus: focus,
            text: $text
        )
        .onAppear { text = amount?.amountText ?? "" }
        .onChange(of: text) { amount = Decimal(amountText: text) }
    }
}

#Preview {
    @Previewable @State var amount: Decimal? = 1280.5
    @Previewable @FocusState var focus: ReceiptField?
    Form { AmountField(field: .total, issues: [], focus: $focus, amount: $amount) }
}
