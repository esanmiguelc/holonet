import SwiftUI

struct ScanImage: View {
    let data: Data
    let size: CGSize
    @Environment(\.displayScale) private var displayScale
    @State private var thumbnail: UIImage?

    var body: some View {
        Group {
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 8))
            }
        }
        .frame(width: size.width, height: size.height)
        .accessibilityLabel("Scanned receipt")
        .task(id: data) {
            let pixelSize = CGSize(width: size.width * displayScale, height: size.height * displayScale)
            thumbnail = await UIImage(data: data)?.byPreparingThumbnail(ofSize: pixelSize)
        }
    }
}
