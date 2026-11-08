import SwiftUI

struct ZoomableImage: UIViewRepresentable {
    private static let maximumZoomScale: CGFloat = 6
    private static let doubleTapZoomScale: CGFloat = 3

    let image: UIImage
    let accessibilityText: String

    func makeUIView(context: Context) -> UIScrollView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = accessibilityText

        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = Self.maximumZoomScale
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        imageView.frame = scrollView.bounds
        scrollView.addSubview(imageView)

        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.toggleZoom(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        context.coordinator.imageView = imageView
        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, UIScrollViewDelegate {
        weak var imageView: UIImageView?

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            imageView
        }

        @objc func toggleZoom(_ gesture: UITapGestureRecognizer) {
            guard let scrollView = gesture.view as? UIScrollView else { return }
            let isZoomedOut = scrollView.zoomScale <= scrollView.minimumZoomScale
            scrollView.setZoomScale(isZoomedOut ? ZoomableImage.doubleTapZoomScale : scrollView.minimumZoomScale, animated: true)
        }
    }
}
