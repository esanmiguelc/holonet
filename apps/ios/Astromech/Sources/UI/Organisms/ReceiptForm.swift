import SwiftUI

struct ReceiptForm: View {
    @Binding var draft: ReceiptDraft

    var body: some View {
        if let scanImage = draft.scanImage {
            Section {
                ScanImage(data: scanImage)
                    .frame(maxWidth: .infinity, maxHeight: 280)
            }
        }

        Section("Issuer") {
            row(.businessName) {
                TextField(ReceiptField.businessName.title, text: $draft.businessName)
                    .textInputAutocapitalization(.words)
            }
            row(.rnc) {
                LabeledContent(ReceiptField.rnc.title) {
                    TextField("9 or 11 digits", text: $draft.rncText)
                        .keyboardType(.numbersAndPunctuation)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.trailing)
                        .monospacedDigit()
                }
            }
        }

        Section("Comprobante") {
            row(.ncf) {
                LabeledContent(ReceiptField.ncf.title) {
                    TextField("B0100000000", text: $draft.ncfText)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.trailing)
                        .monospacedDigit()
                }
            }
            row(.invoiceDate) {
                OptionalDatePicker(title: ReceiptField.invoiceDate.title, date: $draft.invoiceDate)
            }
        }

        Section("Amounts (DOP)") {
            row(.subtotal) { AmountField(title: ReceiptField.subtotal.title, amount: $draft.amounts.subtotal) }
            row(.itbis) { AmountField(title: ReceiptField.itbis.title, amount: $draft.amounts.itbis) }
            row(.propina) { AmountField(title: ReceiptField.propina.title, amount: $draft.amounts.propina) }
            row(.total) { AmountField(title: ReceiptField.total.title, amount: $draft.amounts.total) }
        }
    }

    private func row<Content: View>(_ field: ReceiptField, @ViewBuilder content: () -> Content) -> some View {
        ValidatedRow(issues: draft.issues(for: field), content: content)
    }
}

#Preview {
    @Previewable @State var draft = ReceiptDraft(
        businessName: "Supermercado Nacional",
        rncText: "101010633",
        ncfText: "B0100000123",
        amounts: ReceiptAmounts(subtotal: 1000, itbis: 180, total: 1280)
    )
    Form { ReceiptForm(draft: $draft) }
}
