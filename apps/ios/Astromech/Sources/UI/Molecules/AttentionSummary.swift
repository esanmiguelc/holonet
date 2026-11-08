import SwiftUI

struct AttentionSummary: View {
    let message: String

    var body: some View {
        Label(message, systemImage: "exclamationmark.triangle.fill")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Color.warning)
    }
}

#Preview {
    Form { AttentionSummary(message: "3 fields need attention") }
}
