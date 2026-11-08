import CoreGraphics
import Foundation
import Vision

struct VisionReceiptTextRecognizer: ReceiptTextRecognizing {
    func recognizeText(in pages: [CGImage]) async throws -> String {
        var request = RecognizeDocumentsRequest()
        request.textRecognitionOptions.recognitionLanguages = [
            Locale.Language(identifier: "es-ES"),
            Locale.Language(identifier: "en-US"),
        ]
        request.textRecognitionOptions.useLanguageCorrection = false

        var transcripts: [String] = []
        for page in pages {
            let observations = try await request.perform(on: page)
            transcripts += observations.map(\.document.text.transcript)
        }
        return transcripts.joined(separator: "\n\n")
    }
}
