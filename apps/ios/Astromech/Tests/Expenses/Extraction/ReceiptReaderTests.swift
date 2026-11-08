import CoreGraphics
import Foundation
import Testing
@testable import Astromech

struct ReceiptReaderTests {
    struct StubRecognizer: ReceiptTextRecognizing {
        let result: Result<String, ReceiptReadingFailure>
        func recognizeText(in pages: [CGImage]) async throws -> String { try result.get() }
    }

    struct StubExtractor: ReceiptExtracting {
        let result: Result<ReceiptExtraction, ReceiptReadingFailure>
        func extract(from text: String) async throws(ReceiptReadingFailure) -> ReceiptExtraction { try result.get() }
    }

    static let cover = Data([0xFF, 0xD8])
    static let document = ScannedDocument(pages: [], coverImage: cover)

    static func reader(
        text: Result<String, ReceiptReadingFailure> = .success("SUPERMERCADO NACIONAL\nTOTAL 1,180.00"),
        extraction: Result<ReceiptExtraction, ReceiptReadingFailure> = .success(ReceiptExtraction(businessName: "Supermercado Nacional", total: 1180))
    ) -> ReceiptReader {
        ReceiptReader(recognizer: StubRecognizer(result: text), extractor: StubExtractor(result: extraction))
    }

    @Test func decodesTheExtractionAndKeepsTheCoverImage() async {
        let reading = await Self.reader().read(Self.document)

        #expect(reading.failure == nil)
        #expect(reading.draft.businessName == "Supermercado Nacional")
        #expect(reading.draft.amounts.total == 1180)
        #expect(reading.draft.scanImage == Self.cover)
    }

    @Test func fallsBackToAnEmptyDraftWhenTheModelIsUnavailable() async {
        let reading = await Self.reader(extraction: .failure(.modelUnavailable(.appleIntelligenceNotEnabled))).read(Self.document)

        #expect(reading.failure == .modelUnavailable(.appleIntelligenceNotEnabled))
        #expect(reading.draft == ReceiptDraft(scanImage: Self.cover))
    }

    @Test func reportsWhenTheScanHasNoReadableText() async {
        let reading = await Self.reader(text: .success(" \n ")).read(Self.document)

        #expect(reading.failure == .noTextFound)
        #expect(reading.draft == ReceiptDraft(scanImage: Self.cover))
    }

    @Test func reportsWhenTextRecognitionFails() async {
        let reading = await Self.reader(text: .failure(.textRecognitionFailed)).read(Self.document)

        #expect(reading.failure == .textRecognitionFailed)
    }

    @Test func reportsWhenExtractionFails() async {
        let reading = await Self.reader(extraction: .failure(.extractionFailed)).read(Self.document)

        #expect(reading.failure == .extractionFailed)
        #expect(reading.draft == ReceiptDraft(scanImage: Self.cover))
    }
}
