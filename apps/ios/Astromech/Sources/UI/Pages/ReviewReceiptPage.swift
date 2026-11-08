import SwiftUI

struct ReviewReceiptPage: View {
    let failure: ReceiptReadingFailure?
    let onSave: (ReceiptDraft) -> Void
    let onDiscard: () -> Void
    @State private var draft: ReceiptDraft
    @State private var isConfirmingDiscard = false

    init(
        reading: ReceiptReading,
        onSave: @escaping (ReceiptDraft) -> Void,
        onDiscard: @escaping () -> Void
    ) {
        failure = reading.failure
        self.onSave = onSave
        self.onDiscard = onDiscard
        _draft = State(initialValue: reading.draft)
    }

    var body: some View {
        NavigationStack {
            Form {
                if let failure {
                    NoticeBanner(message: failure.message)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                ReceiptForm(draft: $draft)
            }
            .navigationTitle("Review Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Discard", role: .destructive, action: discard)
                        .confirmationDialog("Discard this receipt?", isPresented: $isConfirmingDiscard, titleVisibility: .visible) {
                            Button("Discard Receipt", role: .destructive, action: onDiscard)
                        } message: {
                            Text("The scan and anything you've entered will be lost.")
                        }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { onSave(draft) }
                }
            }
        }
        .interactiveDismissDisabled()
    }

    private func discard() {
        if draft.isEmpty {
            onDiscard()
        } else {
            isConfirmingDiscard = true
        }
    }
}

#Preview("Extracted") {
    ReviewReceiptPage(
        reading: ReceiptReading(
            draft: ReceiptDraft(
                businessName: "Supermercado Nacional",
                rncText: "101010632",
                ncfText: "B0100000123",
                invoiceDate: .now,
                amounts: ReceiptAmounts(subtotal: 1000, itbis: 180, propina: 100, total: 1280)
            ),
            failure: nil
        ),
        onSave: { _ in },
        onDiscard: {}
    )
}

#Preview("Model unavailable") {
    ReviewReceiptPage(
        reading: ReceiptReading(draft: ReceiptDraft(), failure: .modelUnavailable(.appleIntelligenceNotEnabled)),
        onSave: { _ in },
        onDiscard: {}
    )
}
