import SwiftUI

struct ExpenseRow: View {
    let expense: Expense
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var usesStackedLayout: Bool { dynamicTypeSize.isAccessibilitySize }

    private var layout: AnyLayout {
        usesStackedLayout
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 8))
            : AnyLayout(HStackLayout(alignment: .firstTextBaseline))
    }

    var body: some View {
        layout {
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.businessName.isBlank ? "Unnamed business" : expense.businessName)
                    .font(.headline)
                Text(expense.dateSummary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if !usesStackedLayout {
                Spacer()
            }
            VStack(alignment: usesStackedLayout ? .leading : .trailing, spacing: 4) {
                Text(expense.total?.currencyText ?? "—")
                    .monospacedDigit()
                    .fixedSize(horizontal: usesStackedLayout, vertical: false)
                if !expense.issues.isEmpty {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color.warning)
                        .accessibilityLabel("Needs review")
                }
            }
        }
    }
}
