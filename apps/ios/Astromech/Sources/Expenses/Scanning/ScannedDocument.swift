import CoreGraphics
import Foundation

struct ScannedDocument: Sendable {
    let pages: [CGImage]
    let coverImage: Data?
}
