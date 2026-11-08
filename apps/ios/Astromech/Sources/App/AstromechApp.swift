import SwiftData
import SwiftUI

@main
struct AstromechApp: App {
    var body: some Scene {
        WindowGroup {
            ExpenseListPage()
        }
        .modelContainer(for: Expense.self)
    }
}
