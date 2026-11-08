import SwiftUI

struct NoticeBanner: View {
    let message: String

    var body: some View {
        Label(message, systemImage: "info.circle.fill")
            .font(.callout)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.yellow.opacity(0.15), in: .rect(cornerRadius: 12))
    }
}

#Preview {
    NoticeBanner(message: ReceiptReadingFailure.modelUnavailable(.appleIntelligenceNotEnabled).message)
        .padding()
}
