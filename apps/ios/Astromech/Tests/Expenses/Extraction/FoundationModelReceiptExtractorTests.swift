import FoundationModels
import Testing
@testable import Astromech

struct FoundationModelReceiptExtractorTests {
    typealias GenerationError = LanguageModelSession.GenerationError
    static let context = GenerationError.Context(debugDescription: "")

    @Test func sendsAShortTranscriptUnchanged() {
        #expect(FoundationModelReceiptExtractor.promptText(from: "RNC 101010632") == "RNC 101010632")
    }

    @Test func keepsTheHeaderAndTotalsOfALongTranscriptAndDropsTheItems() {
        let transcript = "RNC 101010632\n" + String(repeating: "ARROZ 1.00\n", count: 2000) + "TOTAL 1,280.00"

        let prompt = FoundationModelReceiptExtractor.promptText(from: transcript)

        #expect(prompt.hasPrefix("RNC 101010632"))
        #expect(prompt.hasSuffix("TOTAL 1,280.00"))
        #expect(prompt.count <= FoundationModelReceiptExtractor.promptCharacterLimit + 1)
    }

    @Test func reportsAReceiptThatStillOverflowsTheModel() {
        #expect(ReceiptReadingFailure(GenerationError.exceededContextWindowSize(Self.context)) == .receiptTooLong)
    }

    @Test func reportsAnUnsupportedLanguage() {
        #expect(ReceiptReadingFailure(GenerationError.unsupportedLanguageOrLocale(Self.context)) == .unsupportedLanguage)
    }

    @Test func treatsOtherModelErrorsAsAFailedExtraction() {
        #expect(ReceiptReadingFailure(GenerationError.guardrailViolation(Self.context)) == .extractionFailed)
    }
}
