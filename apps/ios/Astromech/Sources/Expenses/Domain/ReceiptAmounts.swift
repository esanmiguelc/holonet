import Foundation

struct ReceiptAmounts: Equatable, Sendable {
    static let reconciliationTolerance: Decimal = 1

    var subtotal: Decimal?
    var itbis: Decimal?
    var propina: Decimal?
    var total: Decimal?

    var reconciliationIssue: ReceiptIssue? {
        guard let subtotal, let itbis, let total else { return nil }
        let expectedTotal = subtotal + itbis + (propina ?? 0)
        guard abs(expectedTotal - total) > Self.reconciliationTolerance else { return nil }
        return .amountsDoNotAddUp(expectedTotal: expectedTotal)
    }
}
