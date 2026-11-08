import SwiftUI

struct IssueLabel: View {
    let message: String
    var font = Font.footnote

    var body: some View {
        Label(message, systemImage: "exclamationmark.triangle.fill")
            .font(font)
            .foregroundStyle(Color.warning)
    }
}

#Preview {
    VStack(alignment: .leading) {
        IssueLabel(message: "Not a valid RNC or cédula. Check the digits.")
        IssueLabel(message: "Subtotal + ITBIS + propina comes to RD$1,180.00")
    }
}
