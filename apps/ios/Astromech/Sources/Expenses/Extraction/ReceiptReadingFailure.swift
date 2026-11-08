enum ModelUnavailability: Equatable, Sendable {
    case deviceNotEligible
    case appleIntelligenceNotEnabled
    case modelNotReady
    case unknown
}

enum ReceiptReadingFailure: Error, Equatable, Sendable {
    case textRecognitionFailed
    case noTextFound
    case modelUnavailable(ModelUnavailability)
    case receiptTooLong
    case unsupportedLanguage
    case extractionFailed
}
