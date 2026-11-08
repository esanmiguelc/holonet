import SwiftUI

struct ExpenseDetailPage: View {
    let expense: Expense
    @State private var draft: ReceiptDraft

    init(expense: Expense) {
        self.expense = expense
        _draft = State(initialValue: expense.draft)
    }

    var body: some View {
        ReceiptForm(draft: $draft)
        .navigationTitle(expense.businessName.isBlank ? "Expense" : expense.businessName)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: draft) { expense.draft = draft }
    }
}
