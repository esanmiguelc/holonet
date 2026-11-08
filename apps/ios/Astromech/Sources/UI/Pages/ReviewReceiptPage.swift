import SwiftUI

struct ReviewReceiptPage: View {
    let reading: Task<ReceiptReading, Never>
    let onSave: (ReceiptDraft) -> Void
    let onDiscard: () -> Void
    @State private var draft: ReceiptDraft
    @State private var phase = ReceiptReviewPhase.reading
    @State private var isConfirmingDiscard = false

    init(
        coverImage: Data?,
        reading: Task<ReceiptReading, Never>,
        onSave: @escaping (ReceiptDraft) -> Void,
        onDiscard: @escaping () -> Void
    ) {
        self.reading = reading
        self.onSave = onSave
        self.onDiscard = onDiscard
        _draft = State(initialValue: ReceiptDraft(scanImage: coverImage))
    }

    var body: some View {
        NavigationStack {
            ReceiptForm(draft: $draft, missingFields: phase.missingFields, isLoading: phase.isReading) {
                phaseBanner
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
                    Button("Save", action: save)
                        .disabled(phase.isReading)
                }
            }
        }
        .interactiveDismissDisabled()
        .task { await finishReading() }
        .onChange(of: draft) { phase.draftDidChange(to: draft) }
    }

    @ViewBuilder
    private var phaseBanner: some View {
        switch phase {
        case .reading:
            banner("Reading receipt…", style: .progress)
        case .reviewing(readFailure: let failure?):
            banner(failure.message, style: .caution)
        case .reviewing(readFailure: nil):
            banner("Read on this device by Apple Intelligence. Check it against the receipt.", style: .information)
        case .confirmingIncomplete:
            banner("Some details are missing. Tap Save again to keep this expense anyway.", style: .caution)
        }
    }

    private func banner(_ message: String, style: NoticeStyle) -> some View {
        NoticeBanner(message: message, style: style)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
    }

    private func finishReading() async {
        let result = await withTaskCancellationHandler {
            await reading.value
        } onCancel: {
            reading.cancel()
        }
        guard !Task.isCancelled else { return }
        draft = result.draft
        phase = .reviewing(readFailure: result.failure)
    }

    private func save() {
        if phase.requestSave(of: draft) {
            onSave(draft)
        }
    }

    private func discard() {
        if draft.isEmpty {
            onDiscard()
        } else {
            isConfirmingDiscard = true
        }
    }
}

@MainActor
private func previewPage(_ reading: ReceiptReading) -> some View {
    ReviewReceiptPage(coverImage: nil, reading: Task { reading }, onSave: { _ in }, onDiscard: {})
}

#Preview("Extracted") {
    previewPage(ReceiptReading(
        draft: ReceiptDraft(
            businessName: "Supermercado Nacional",
            rncText: "1-01-01063-2",
            ncfText: "B0100000123",
            invoiceDate: .now,
            amounts: ReceiptAmounts(subtotal: 1000, itbis: 180, propina: 100, total: 1280)
        ),
        failure: nil
    ))
}

#Preview("Model unavailable") {
    previewPage(ReceiptReading(draft: ReceiptDraft(), failure: .modelUnavailable(.appleIntelligenceNotEnabled)))
}
