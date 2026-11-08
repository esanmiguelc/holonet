import SwiftUI

enum NoticeStyle {
    case caution
    case information
}

struct NoticeBanner: View {
    let message: String
    var style = NoticeStyle.caution

    var body: some View {
        Label(message, systemImage: systemImage)
            .font(.callout)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(background, in: .rect(cornerRadius: 12))
    }

    private var systemImage: String {
        switch style {
        case .caution: "info.circle.fill"
        case .information: "sparkles"
        }
    }

    private var background: Color {
        switch style {
        case .caution: .yellow.opacity(0.15)
        case .information: Color(.secondarySystemGroupedBackground)
        }
    }
}

#Preview {
    VStack {
        NoticeBanner(message: ReceiptReadingFailure.modelUnavailable(.appleIntelligenceNotEnabled).message)
        NoticeBanner(message: "Read on this device by Apple Intelligence. Check it against the receipt.", style: .information)
    }
    .padding()
}
