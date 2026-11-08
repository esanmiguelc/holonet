import SwiftData
import SwiftUI

struct ExpenseListPage: View {
    private struct PendingReview: Identifiable {
        let id = UUID()
        let coverImage: Data?
        let reading: Task<ReceiptReading, Never>
    }

    private enum ScanOutcome {
        case scanned(PendingReview)
        case failed
    }

    @Environment(\.modelContext) private var modelContext
    @Environment(\.receiptReader) private var receiptReader
    @Query(sort: \Expense.createdAt, order: .reverse) private var expenses: [Expense]
    @State private var isScanning = false
    @State private var scanOutcome: ScanOutcome?
    @State private var isShowingScanFailure = false
    @State private var pendingReview: PendingReview?

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Expenses")
                .navigationDestination(for: Expense.self, destination: ExpenseDetailPage.init)
                .toolbar {
                    if !expenses.isEmpty {
                        ToolbarItem(placement: .primaryAction) {
                            scanButton
                        }
                    }
                }
        }
        .fullScreenCover(isPresented: $isScanning, onDismiss: presentScanOutcome) {
            DocumentScannerView(onScan: finishScanning, onFailure: failScanning, onCancel: { isScanning = false })
                .ignoresSafeArea()
        }
        .sheet(item: $pendingReview) { review in
            ReviewReceiptPage(coverImage: review.coverImage, reading: review.reading, onSave: save, onDiscard: { pendingReview = nil })
        }
        .alert("Scan Failed", isPresented: $isShowingScanFailure) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The scan couldn't be completed. Please try again.")
        }
    }

    @ViewBuilder
    private var content: some View {
        if expenses.isEmpty {
            ContentUnavailableView {
                Label("No Expenses", systemImage: "doc.viewfinder")
            } description: {
                Text(DocumentScannerView.isSupported
                    ? "Scan a receipt to record its RNC, NCF, ITBIS and totals."
                    : "This device has no camera that can scan documents.")
            } actions: {
                scanButton.buttonStyle(.borderedProminent)
            }
        } else {
            List {
                ForEach(expenses) { expense in
                    NavigationLink(value: expense) {
                        ExpenseRow(expense: expense)
                    }
                }
                .onDelete(perform: delete)
            }
        }
    }

    private var scanButton: some View {
        Button("Scan Receipt", systemImage: "doc.viewfinder") { isScanning = true }
            .disabled(!DocumentScannerView.isSupported)
    }

    private func finishScanning(_ document: ScannedDocument) {
        let reader = receiptReader
        scanOutcome = .scanned(PendingReview(
            coverImage: document.coverImage,
            reading: Task { await reader.read(document) }
        ))
        isScanning = false
    }

    private func failScanning() {
        scanOutcome = .failed
        isScanning = false
    }

    private func presentScanOutcome() {
        switch scanOutcome {
        case .scanned(let review): pendingReview = review
        case .failed: isShowingScanFailure = true
        case nil: break
        }
        scanOutcome = nil
    }

    private func save(_ draft: ReceiptDraft) {
        modelContext.insert(Expense(draft: draft))
        pendingReview = nil
    }

    private func delete(at offsets: IndexSet) {
        offsets.map { expenses[$0] }.forEach(modelContext.delete)
    }
}

#Preview {
    ExpenseListPage()
        .modelContainer(for: Expense.self, inMemory: true)
}
