import Testing
import UIKit
@testable import Astromech

struct ScanCoverTests {
    static func image(width: CGFloat, height: CGFloat) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: format).image { context in
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        }
    }

    @Test func shrinksALargeScanToTheCoverSizeKeepingItsShape() throws {
        let cover = try #require(UIImage(data: Self.image(width: 3000, height: 6000).scanCoverJPEG))
        #expect(cover.size == CGSize(width: 1200, height: 2400))
    }

    @Test func neverEnlargesASmallScan() throws {
        let cover = try #require(UIImage(data: Self.image(width: 800, height: 600).scanCoverJPEG))
        #expect(cover.size == CGSize(width: 800, height: 600))
    }
}
