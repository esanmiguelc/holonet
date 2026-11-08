import SwiftUI

struct AmountField<Focus: Hashable>: View {
    let title: String
    let hint: String
    let focus: FocusState<Focus?>.Binding
    let focusValue: Focus
    @Binding var amount: Decimal?
    @State private var text = ""

    var body: some View {
        FormTextField(
            label: title,
            prompt: "0.00",
            input: .amount,
            accessibilityName: title,
            hint: hint,
            focus: focus,
            focusValue: focusValue,
            text: $text
        )
        .onAppear { text = amount?.amountText ?? "" }
        .onChange(of: focus.wrappedValue) { previous, current in
            if previous == focusValue, current != focusValue {
                text = amount?.amountText ?? ""
            }
        }
        .onChange(of: text) {
            if !amount.isDisplayed(as: text) {
                amount = Decimal(amountText: text)
            }
        }
        .onChange(of: amount) {
            if !amount.isDisplayed(as: text), Decimal(amountText: text) != amount {
                text = amount?.amountText ?? ""
            }
        }
    }
}

#Preview {
    @Previewable @State var amount: Decimal? = 1280.5
    @Previewable @FocusState var focus: String?
    Form { AmountField(title: "Total", hint: "", focus: $focus, focusValue: "total", amount: $amount) }
}
