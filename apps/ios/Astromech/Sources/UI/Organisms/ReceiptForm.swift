import SwiftUI

struct ReceiptForm<Notice: View>: View {
    @Binding var draft: ReceiptDraft
    var missingFields = MissingFieldVisibility.flagged
    var isLoading = false
    @ViewBuilder let notice: Notice
    @FocusState private var focusedField: ReceiptField?
    @State private var isViewingScan = false

    var body: some View {
        Form {
            Section { notice }

            if let message = draft.attentionMessage(missingFields: missingFields) {
                Section { AttentionSummary(message: message) }
            }

            if let scanImage = draft.scanImage {
                Section {
                    ScanThumbnailButton(data: scanImage) { isViewingScan = true }
                }
            }

            Group {
                Section("Business") {
                    textRow(.businessName, label: "Name", prompt: ReceiptField.businessName.title, input: .name, text: $draft.businessName)
                    textRow(.rnc, label: ReceiptField.rnc.title, prompt: "9 or 11 digits", input: .documentNumber, text: $draft.rncText)
                }

                Section("Receipt") {
                    textRow(.ncf, label: ReceiptField.ncf.title, prompt: "B0100000000", input: .code, text: $draft.ncfText)
                    OptionalDatePicker(title: ReceiptField.invoiceDate.title, date: $draft.invoiceDate)
                }

                Section("Amounts (RD$)") {
                    amountRow(.subtotal, amount: $draft.amounts.subtotal)
                    amountRow(.itbis, amount: $draft.amounts.itbis)
                    amountRow(.propina, amount: $draft.amounts.propina)
                    amountRow(.total, amount: $draft.amounts.total)
                }
            }
            .disabled(isLoading)
            .redacted(reason: isLoading ? .placeholder : [])
        }
        .fullScreenCover(isPresented: $isViewingScan) {
            if let scanImage = draft.scanImage {
                ScanViewerPage(data: scanImage)
            }
        }
        .onSubmit(focusNextField)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Next Field", systemImage: "chevron.down", action: focusNextField)
                    .disabled(focusedField?.nextInEditingOrder == nil)
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
    }

    private func textRow(
        _ field: ReceiptField,
        label: String,
        prompt: String,
        input: FormTextInput,
        text: Binding<String>
    ) -> some View {
        let issues = draft.issues(for: field, missingFields: missingFields)
        return ValidatedRow(issues: issues) {
            FormTextField(field: field, label: label, prompt: prompt, input: input, issues: issues, focus: $focusedField, text: text)
        }
    }

    private func amountRow(_ field: ReceiptField, amount: Binding<Decimal?>) -> some View {
        let issues = draft.issues(for: field, missingFields: missingFields)
        return ValidatedRow(issues: issues) {
            AmountField(field: field, issues: issues, focus: $focusedField, amount: amount)
        }
    }

    private func focusNextField() {
        focusedField = focusedField?.nextInEditingOrder
    }
}

extension ReceiptForm where Notice == EmptyView {
    init(draft: Binding<ReceiptDraft>) {
        self.init(draft: draft) { EmptyView() }
    }
}

#Preview {
    @Previewable @State var draft = ReceiptDraft(
        businessName: "Supermercado Nacional",
        rncText: "101010633",
        ncfText: "B0100000123",
        amounts: ReceiptAmounts(subtotal: 1000, itbis: 180, total: 1280)
    )
    NavigationStack { ReceiptForm(draft: $draft) }
}
