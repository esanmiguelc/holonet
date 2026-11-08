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

struct FormTextField<Focus: Hashable>: View {
    let label: String
    let prompt: String
    let input: FormTextInput
    let accessibilityName: String
    let hint: String
    let focus: FocusState<Focus?>.Binding
    let focusValue: Focus
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
                .focused(focus, equals: focusValue)
                .accessibilityLabel(accessibilityName)
                .accessibilityHint(hint)
        }
    }
}

#Preview {
    @Previewable @State var text = "101010633"
    @Previewable @FocusState var focus: String?
    Form {
        FormTextField(
            label: "RNC",
            prompt: "9 or 11 digits",
            input: .documentNumber,
            accessibilityName: "RNC",
            hint: "",
            focus: $focus,
            focusValue: "rnc",
            text: $text
        )
    }
}
