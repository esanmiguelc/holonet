enum ReceiptReviewPhase: Equatable, Sendable {
    case reading
    case reviewing(readFailure: ReceiptReadingFailure?)
    case confirmingIncomplete(readFailure: ReceiptReadingFailure)

    var isReading: Bool { self == .reading }

    var missingFields: MissingFieldVisibility {
        switch self {
        case .reading, .reviewing(readFailure: .some): .deferred
        case .reviewing(readFailure: nil), .confirmingIncomplete: .flagged
        }
    }

    mutating func requestSave(of draft: ReceiptDraft) -> Bool {
        switch self {
        case .reading:
            return false
        case .reviewing(readFailure: let failure?) where draft.isMissingFields:
            self = .confirmingIncomplete(readFailure: failure)
            return false
        case .reviewing, .confirmingIncomplete:
            return true
        }
    }

    mutating func draftDidChange(to draft: ReceiptDraft) {
        if case .confirmingIncomplete(let failure) = self, !draft.isMissingFields {
            self = .reviewing(readFailure: failure)
        }
    }
}

private extension ReceiptDraft {
    var isMissingFields: Bool { issues.contains(where: \.isMissingField) }
}
