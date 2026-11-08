import SwiftUI

struct ExpenseRow: View {
    let expense: Expense

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.businessName.isBlank ? "Unnamed business" : expense.businessName)
                    .font(.headline)
                Text((expense.invoiceDate ?? expense.createdAt).formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(expense.total?.currencyText ?? "—")
                    .monospacedDigit()
                if !expense.issues.isEmpty {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                        .accessibilityLabel("Needs review")
                }
            }
        }
    }
}
