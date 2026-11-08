import SwiftUI
import VisionKit

struct DocumentScannerView: UIViewControllerRepresentable {
    static var isSupported: Bool { VNDocumentCameraViewController.isSupported }

    let onScan: (ScannedDocument) -> Void
    let onFailure: () -> Void
    let onCancel: () -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ scanner: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onScan: onScan, onFailure: onFailure, onCancel: onCancel)
    }

    @MainActor
    final class Coordinator: NSObject, @preconcurrency VNDocumentCameraViewControllerDelegate {
        let onScan: (ScannedDocument) -> Void
        let onFailure: () -> Void
        let onCancel: () -> Void

        init(onScan: @escaping (ScannedDocument) -> Void, onFailure: @escaping () -> Void, onCancel: @escaping () -> Void) {
            self.onScan = onScan
            self.onFailure = onFailure
            self.onCancel = onCancel
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let images = (0..<scan.pageCount).map(scan.imageOfPage(at:))
            let firstPage = images.first
            Task {
                let coverImage = await Task.detached { firstPage?.scanCoverJPEG }.value
                onScan(ScannedDocument(pages: images.compactMap(\.cgImage), coverImage: coverImage))
            }
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            onCancel()
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            onFailure()
        }
    }
}
