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
    func editableTextRoundTrips(value: String) {
        let amount = Decimal.exactly(value)
        #expect(Decimal(amountText: amount.amountText) == amount)
    }

    @Test func editableTextIsGroupedLikeAPrintedReceiptRegardlessOfDeviceLocale() {
        #expect(Decimal.exactly("1234567.89").amountText == "1,234,567.89")
    }

    @Test func aMoreAccurateAmountCountsAsDisplayedByItsRoundedText() {
        let amount: Decimal? = .exactly("1.234")
        #expect(amount.isDisplayed(as: "1.23"))
        #expect(!amount.isDisplayed(as: "1.24"))
    }

    @Test func noAmountIsDisplayedAsAnEmptyField() {
        let amount: Decimal? = nil
        #expect(amount.isDisplayed(as: ""))
        #expect(!amount.isDisplayed(as: "12"))
    }

    @Test func currencyTextUsesTheDominicanPesoSymbol() {
        #expect(Decimal.exactly("16000").currencyText == "RD$16,000.00")
    }
}
