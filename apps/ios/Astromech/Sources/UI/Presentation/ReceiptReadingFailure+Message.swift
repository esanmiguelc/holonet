extension ReceiptReadingFailure {
    var message: String {
        switch self {
        case .textRecognitionFailed:
            "The scan couldn't be read. Enter the details below."
        case .noTextFound:
            "No text was found in the scan. Enter the details below."
        case .modelUnavailable(.deviceNotEligible):
            "This device doesn't support Apple Intelligence, so receipts can't be read automatically. Enter the details below."
        case .modelUnavailable(.appleIntelligenceNotEnabled):
            "Turn on Apple Intelligence in Settings to read receipts automatically. For now, enter the details below."
        case .modelUnavailable(.modelNotReady):
            "Apple Intelligence is still getting ready on this device. Enter the details below, or try scanning again later."
        case .modelUnavailable(.unknown):
            "Apple Intelligence isn't available right now. Enter the details below."
        case .receiptTooLong:
            "This receipt is too long to read automatically. Enter the details below."
        case .unsupportedLanguage:
            "Apple Intelligence doesn't support this device's language yet. Enter the details below."
        case .extractionFailed:
            "The receipt details couldn't be extracted. Enter them below."
        }
    }
}
