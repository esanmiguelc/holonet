import CoreGraphics
import UIKit

enum ReceiptImageFixture {
    static let lines = [
        "SUPERMERCADO NACIONAL",
        "RNC: 1-01-01063-2",
        "NCF: B0100000123",
        "FECHA: 07/11/2026",
        "SUBTOTAL        1,000.00",
        "ITBIS 18%         180.00",
        "PROPINA LEGAL 10% 100.00",
        "TOTAL           1,280.00",
    ]

    static func render() -> CGImage {
        let size = CGSize(width: 900, height: 1200)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let image = UIGraphicsImageRenderer(size: size, format: format).image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 40, weight: .regular),
                .foregroundColor: UIColor.black,
            ]
            for (index, line) in lines.enumerated() {
                (line as NSString).draw(at: CGPoint(x: 60, y: 80 + index * 110), withAttributes: attributes)
            }
        }
        return image.cgImage!
    }
}
