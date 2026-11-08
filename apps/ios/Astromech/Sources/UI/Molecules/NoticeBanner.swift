import SwiftUI

enum NoticeStyle {
    case caution
    case information
    case progress
}

struct NoticeBanner: View {
    let message: String
    var style = NoticeStyle.caution

    var body: some View {
        Label {
            Text(message)
        } icon: {
            icon
        }
        .font(.callout)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background, in: .rect(cornerRadius: 12))
    }

    @ViewBuilder
    private var icon: some View {
        switch style {
        case .caution: Image(systemName: "info.circle.fill")
        case .information: Image(systemName: "sparkles")
        case .progress: ProgressView()
        }
    }

    private var background: Color {
        switch style {
        case .caution: .yellow.opacity(0.15)
        case .information, .progress: Color(.secondarySystemGroupedBackground)
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
