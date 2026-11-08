import SwiftUI

struct IssueLabel: View {
    let issue: ReceiptIssue

    var body: some View {
        Label(issue.message, systemImage: "exclamationmark.triangle.fill")
            .font(.footnote)
            .foregroundStyle(.orange)
    }
}

#Preview {
    VStack(alignment: .leading) {
        IssueLabel(issue: .unrecognizedRNC)
        IssueLabel(issue: .amountsDoNotAddUp(expectedTotal: 1180))
    }
}
