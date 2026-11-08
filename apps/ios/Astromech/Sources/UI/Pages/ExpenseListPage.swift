import SwiftData
import SwiftUI

struct ExpenseListPage: View {
    private struct PendingReview: Identifiable {
        let id = UUID()
        let reading: ReceiptReading
    }

    @Environment(\.modelContext) private var modelContext
    @Environment(\.receiptReader) private var receiptReader
    @Query(sort: \Expense.createdAt, order: .reverse) private var expenses: [Expense]
    @State private var isScanning = false
    @State private var isReading = false
    @State private var pendingReview: PendingReview?

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Expenses")
                .navigationDestination(for: Expense.self, destination: ExpenseDetailPage.init)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        scanButton
                    }
                }
                .overlay {
                    if isReading {
                        ProgressView("Reading receipt…")
                            .padding()
                            .background(.regularMaterial, in: .rect(cornerRadius: 12))
                    }
                }
        }
        .fullScreenCover(isPresented: $isScanning) {
            DocumentScannerView(onScan: read, onCancel: { isScanning = false })
                .ignoresSafeArea()
        }
        .sheet(item: $pendingReview) { review in
            ReviewReceiptPage(reading: review.reading, onSave: save, onDiscard: { pendingReview = nil })
        }
    }

    @ViewBuilder
    private var content: some View {
        if expenses.isEmpty {
            ContentUnavailableView {
                Label("No Expenses", systemImage: "doc.text.viewfinder")
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
            .disabled(!DocumentScannerView.isSupported || isReading)
    }

    private func read(_ document: ScannedDocument) {
        isScanning = false
        isReading = true
        Task {
            pendingReview = PendingReview(reading: await receiptReader.read(document))
            isReading = false
        }
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
