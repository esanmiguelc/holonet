import SwiftUI

enum FormTextInput {
    case name
    case documentNumber
    case code
    case amount

    var keyboard: UIKeyboardType {
        switch self {
        case .name, .code: .default
        case .documentNumber: .numbersAndPunctuation
        case .amount: .decimalPad
        }
    }

    var capitalization: TextInputAutocapitalization {
        switch self {
        case .name: .words
        case .code: .characters
        case .documentNumber, .amount: .never
        }
    }
}

struct FormTextField: View {
    let field: ReceiptField
    let label: String
    let prompt: String
    let input: FormTextInput
    let issues: [ReceiptIssue]
    let focus: FocusState<ReceiptField?>.Binding
    @Binding var text: String

    var body: some View {
        LabeledContent(label) {
            TextField(prompt, text: $text)
                .keyboardType(input.keyboard)
                .textInputAutocapitalization(input.capitalization)
                .autocorrectionDisabled()
                .multilineTextAlignment(.trailing)
                .monospacedDigit()
                .submitLabel(.next)
                .focused(focus, equals: field)
                .accessibilityLabel(field.title)
                .accessibilityHint(issues.map(\.message).joined(separator: " "))
        }
    }
}

#Preview {
    @Previewable @State var text = "101010633"
    @Previewable @FocusState var focus: ReceiptField?
    Form {
        FormTextField(
            field: .rnc,
            label: ReceiptField.rnc.title,
            prompt: "9 or 11 digits",
            input: .documentNumber,
            issues: [.unrecognizedRNC],
            focus: $focus,
            text: $text
        )
    }
}
