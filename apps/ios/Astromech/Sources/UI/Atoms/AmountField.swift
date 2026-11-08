import SwiftUI

struct AmountField: View {
    let title: String
    @Binding var amount: Decimal?
    @State private var text = ""

    var body: some View {
        LabeledContent(title) {
            TextField("0.00", text: $text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .monospacedDigit()
        }
        .onAppear { text = amount?.amountText ?? "" }
        .onChange(of: text) { amount = Decimal(amountText: text) }
    }
}

#Preview {
    @Previewable @State var amount: Decimal? = 1280.5
    Form { AmountField(title: "Total", amount: $amount) }
}
