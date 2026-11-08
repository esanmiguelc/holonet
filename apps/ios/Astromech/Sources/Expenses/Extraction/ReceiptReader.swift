import CoreGraphics

protocol ReceiptTextRecognizing: Sendable {
    func recognizeText(in pages: [CGImage]) async throws -> String
}

protocol ReceiptExtracting: Sendable {
    func extract(from text: String) async throws(ReceiptReadingFailure) -> ReceiptExtraction
}

struct ReceiptReading: Equatable, Sendable {
    let draft: ReceiptDraft
    let failure: ReceiptReadingFailure?
}

struct ReceiptReader: Sendable {
    let recognizer: any ReceiptTextRecognizing
    let extractor: any ReceiptExtracting

    func read(_ document: ScannedDocument) async -> ReceiptReading {
        let emptyDraft = ReceiptDraft(scanImage: document.coverImage)

        guard let text = try? await recognizer.recognizeText(in: document.pages) else {
            return ReceiptReading(draft: emptyDraft, failure: .textRecognitionFailed)
        }
        guard !text.isBlank else {
            return ReceiptReading(draft: emptyDraft, failure: .noTextFound)
        }

        do {
            let extraction = try await extractor.extract(from: text)
            return ReceiptReading(draft: ReceiptDraft(decoding: extraction, scanImage: document.coverImage), failure: nil)
        } catch {
            return ReceiptReading(draft: emptyDraft, failure: error)
        }
    }
}
