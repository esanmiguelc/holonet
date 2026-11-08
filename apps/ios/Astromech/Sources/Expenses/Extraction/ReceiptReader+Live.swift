import SwiftUI

extension ReceiptReader {
    static let live = ReceiptReader(
        recognizer: VisionReceiptTextRecognizer(),
        extractor: FoundationModelReceiptExtractor()
    )
}

extension EnvironmentValues {
    @Entry var receiptReader = ReceiptReader.live
}
