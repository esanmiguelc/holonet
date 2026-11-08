import Testing
@testable import Astromech

struct VisionReceiptTextRecognizerTests {
    @Test func transcribesTheFiscalLinesOfAPrintedReceipt() async throws {
        let text = try await VisionReceiptTextRecognizer().recognizeText(in: [ReceiptImageFixture.render()])

        #expect(text.contains("SUPERMERCADO NACIONAL"))
        #expect(text.contains("1-01-01063-2"))
        #expect(text.contains("B0100000123"))
        #expect(text.contains("1,280.00"))
    }

    @Test func returnsNoTextForNoPages() async throws {
        #expect(try await VisionReceiptTextRecognizer().recognizeText(in: []).isEmpty)
    }
}
