import Foundation

extension Expense {
    var dateSummary: String {
        guard let invoiceDate else {
            return "Scanned \(createdAt.formatted(date: .abbreviated, time: .omitted))"
        }
        return invoiceDate.formatted(date: .abbreviated, time: .omitted)
    }
}
