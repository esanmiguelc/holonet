import SwiftUI

struct ScanThumbnailButton: View {
    let data: Data
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ScanImage(data: data, size: CGSize(width: 56, height: 72))
                    .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(.separator))
                Text("View scan")
                Spacer()
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("View scanned receipt")
        .accessibilityAddTraits(.isButton)
    }
}
