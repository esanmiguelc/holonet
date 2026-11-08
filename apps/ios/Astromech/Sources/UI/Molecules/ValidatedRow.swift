import SwiftUI

struct ValidatedRow<Content: View>: View {
    let issues: [ReceiptIssue]
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            content
            ForEach(issues, id: \.self, content: IssueLabel.init)
        }
    }
}

#Preview {
    Form {
        ValidatedRow(issues: [.unrecognizedRNC]) {
            LabeledContent("RNC", value: "101010633")
        }
    }
}
