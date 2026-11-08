import FoundationModels

struct FoundationModelReceiptExtractor: ReceiptExtracting {
    static let promptCharacterLimit = 4000

    private static let instructions = """
        Extraes datos fiscales de recibos y facturas de la República Dominicana a partir de texto \
        obtenido por OCR. El texto puede tener errores de lectura y líneas desordenadas. \
        Copia los valores tal como aparecen; no inventes datos. Si un campo no aparece, déjalo vacío. \
        El RNC y el NCF pertenecen al negocio que emite el recibo, no al cliente.
        """

    func extract(from text: String) async throws(ReceiptReadingFailure) -> ReceiptExtraction {
        let model = SystemLanguageModel.default
        if case .unavailable(let reason) = model.availability {
            throw .modelUnavailable(ModelUnavailability(reason))
        }

        let session = LanguageModelSession(model: model, instructions: Self.instructions)
        do {
            return try await session.respond(
                to: Self.promptText(from: text),
                generating: ReceiptExtraction.self,
                options: GenerationOptions(sampling: .greedy)
            ).content
        } catch let error as LanguageModelSession.GenerationError {
            throw ReceiptReadingFailure(error)
        } catch {
            throw .extractionFailed
        }
    }

    static func promptText(from transcript: String) -> String {
        guard transcript.count > promptCharacterLimit else { return transcript }
        let endLength = promptCharacterLimit / 2
        return "\(transcript.prefix(endLength))\n\(transcript.suffix(endLength))"
    }
}

extension ReceiptReadingFailure {
    init(_ error: LanguageModelSession.GenerationError) {
        switch error {
        case .exceededContextWindowSize: self = .receiptTooLong
        case .unsupportedLanguageOrLocale: self = .unsupportedLanguage
        default: self = .extractionFailed
        }
    }
}

extension ModelUnavailability {
    init(_ reason: SystemLanguageModel.Availability.UnavailableReason) {
        switch reason {
        case .deviceNotEligible: self = .deviceNotEligible
        case .appleIntelligenceNotEnabled: self = .appleIntelligenceNotEnabled
        case .modelNotReady: self = .modelNotReady
        @unknown default: self = .unknown
        }
    }
}
