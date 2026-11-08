import Testing
@testable import Astromech

struct ReceiptFieldEditingOrderTests {
    @Test func movesThroughTheFieldsInFormOrder() {
        #expect(ReceiptField.businessName.nextInEditingOrder == .rnc)
        #expect(ReceiptField.ncf.nextInEditingOrder == .subtotal)
    }

    @Test func stopsAtTheLastField() {
        #expect(ReceiptField.total.nextInEditingOrder == nil)
    }

    @Test func theDatePickerIsNotPartOfTheKeyboardOrder() {
        #expect(ReceiptField.invoiceDate.nextInEditingOrder == nil)
        #expect(!ReceiptField.editingOrder.contains(.invoiceDate))
    }
}
