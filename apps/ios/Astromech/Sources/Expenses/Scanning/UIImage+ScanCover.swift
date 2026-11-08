import UIKit

extension UIImage {
    private static let coverMaximumPixelLength: CGFloat = 2400
    private static let coverCompressionQuality: CGFloat = 0.7

    var scanCoverJPEG: Data {
        let pixelWidth = size.width * scale
        let pixelHeight = size.height * scale
        let ratio = min(1, Self.coverMaximumPixelLength / max(pixelWidth, pixelHeight))
        let coverSize = CGSize(width: (pixelWidth * ratio).rounded(), height: (pixelHeight * ratio).rounded())

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        return UIGraphicsImageRenderer(size: coverSize, format: format)
            .jpegData(withCompressionQuality: Self.coverCompressionQuality) { _ in
                draw(in: CGRect(origin: .zero, size: coverSize))
            }
    }
}
