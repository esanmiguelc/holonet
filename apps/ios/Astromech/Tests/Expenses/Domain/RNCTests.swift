import Testing
@testable import Astromech

struct RNCTests {
    @Test(arguments: ["101010632", "131793916", "1-01-01063-2", " 101 010 632 "])
    func acceptsCompanyRNCsWithAValidCheckDigit(text: String) throws {
        let rnc = try #require(RNC(text))
        #expect(rnc.kind == .company)
        #expect(rnc.digits.count == 9)
    }

    @Test(arguments: ["00113918205", "001-1391820-5"])
    func acceptsCedulasWithAValidCheckDigit(text: String) throws {
        let rnc = try #require(RNC(text))
        #expect(rnc.kind == .individual)
        #expect(rnc.digits == "00113918205")
    }

    @Test(arguments: ["101010633", "00113918206"])
    func rejectsNumbersWhoseCheckDigitDoesNotMatch(text: String) {
        #expect(RNC(text) == nil)
    }

    @Test(arguments: ["", "10101063", "1010106321", "10101O632", "RNC 101010632", "١٠١٠١٠٦٣٢"])
    func rejectsTextThatIsNotNineOrElevenDigits(text: String) {
        #expect(RNC(text) == nil)
    }

    @Test func formatsCompanyRNCsInDGIIGroups() throws {
        #expect(try #require(RNC("101010632")).formatted == "1-01-01063-2")
    }

    @Test func formatsCedulasInDGIIGroups() throws {
        #expect(try #require(RNC("00113918205")).formatted == "001-1391820-5")
    }
}
