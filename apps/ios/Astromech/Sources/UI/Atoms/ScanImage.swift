import SwiftUI

struct ScanImage: View {
    let data: Data

    var body: some View {
        if let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 8))
                .accessibilityLabel("Scanned receipt")
        }
    }
}
