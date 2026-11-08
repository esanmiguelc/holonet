import SwiftUI

struct ValidatedRow<Content: View>: View {
    let messages: [String]
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            content
            ForEach(messages, id: \.self) { IssueLabel(message: $0) }
        }
    }
}

#Preview {
    Form {
        ValidatedRow(messages: ["Not a valid RNC or cédula. Check the digits."]) {
            LabeledContent("RNC", value: "101010633")
        }
    }
}
