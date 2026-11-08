import Foundation
import Testing
@testable import Astromech

struct AmountTextTests {
    @Test(arguments: [
        ("1280", "1280"),
        ("1,280.50", "1280.50"),
        ("1.280,50", "1280.50"),
        ("RD$ 1,280.5", "1280.5"),
        ("$1,280.00", "1280.00"),
        ("1 280,50", "1280.50"),
        ("0.99", "0.99"),
        ("1,280", "1280"),
        ("12,5", "12.5"),
    ])
    func parsesAmountsWithEitherDecimalSeparator(text: String, expected: String) {
        #expect(Decimal(amountText: text) == .exactly(expected))
    }

    @Test(arguments: ["", "  ", "abc", "12x", "1.5 kg", "-", "RD$"])
    func rejectsTextThatIsNotAnAmount(text: String) {
        #expect(Decimal(amountText: text) == nil)
    }

    @Test(arguments: ["1280.5", "0.05", "1234567.89", "0"])
    func editableTextRoundTripsWithoutGroupingOrLocale(value: String) {
        let amount = Decimal.exactly(value)
        #expect(!amount.amountText.contains(","))
        #expect(Decimal(amountText: amount.amountText) == amount)
    }
}
