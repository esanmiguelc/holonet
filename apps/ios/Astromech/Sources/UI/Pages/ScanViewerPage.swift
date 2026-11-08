import SwiftUI

struct ScanViewerPage: View {
    let data: Data
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if let image = UIImage(data: data) {
                    ZoomableImage(image: image, accessibilityText: "Scanned receipt")
                        .ignoresSafeArea(edges: .bottom)
                }
            }
            .navigationTitle("Scan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
