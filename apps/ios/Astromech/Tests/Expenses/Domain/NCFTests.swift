import Testing
@testable import Astromech

struct NCFTests {
    @Test func acceptsPaperComprobantesWithAnEightDigitSequence() throws {
        let ncf = try #require(NCF("B0100000123"))
        #expect(ncf.type == .creditoFiscal)
        #expect(ncf.sequence == "00000123")
    }

    @Test func acceptsElectronicComprobantesWithATenDigitSequence() throws {
        let ncf = try #require(NCF("E320000004521"))
        #expect(ncf.type == .electronicConsumo)
        #expect(ncf.sequence == "0000004521")
    }

    @Test(arguments: ["b01-0000-0123", " B01 00000123 "])
    func normalizesCaseAndSeparators(text: String) throws {
        #expect(try #require(NCF(text)).code == "B0100000123")
    }

    @Test(arguments: [
        "",
        "B0100000",
        "B010000012345",
        "E3100000123",
        "B05000000123",
        "A0100000123",
        "B01000O0123",
    ])
    func rejectsCodesWithUnknownTypesOrWrongSequenceLength(text: String) {
        #expect(NCF(text) == nil)
    }
}
