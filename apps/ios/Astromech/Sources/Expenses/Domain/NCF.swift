import Foundation

enum NCFType: String, CaseIterable, Sendable {
    case creditoFiscal = "B01"
    case consumo = "B02"
    case notaDeDebito = "B03"
    case notaDeCredito = "B04"
    case proveedoresInformales = "B11"
    case registroUnicoDeIngresos = "B12"
    case gastosMenores = "B13"
    case regimenesEspeciales = "B14"
    case gubernamental = "B15"
    case exportaciones = "B16"
    case pagosAlExterior = "B17"
    case electronicCreditoFiscal = "E31"
    case electronicConsumo = "E32"
    case electronicNotaDeDebito = "E33"
    case electronicNotaDeCredito = "E34"
    case electronicCompras = "E41"
    case electronicGastosMenores = "E43"
    case electronicRegimenesEspeciales = "E44"
    case electronicGubernamental = "E45"
    case electronicExportaciones = "E46"
    case electronicPagosAlExterior = "E47"

    var isElectronic: Bool { rawValue.hasPrefix("E") }

    var sequenceLength: Int { isElectronic ? 10 : 8 }
}

struct NCF: Hashable, Sendable {
    let type: NCFType
    let sequence: String

    init?(_ text: String) {
        let code = text.removingDocumentSeparators.uppercased()
        guard let type = NCFType(rawValue: String(code.prefix(3))) else { return nil }

        let sequence = String(code.dropFirst(3))
        guard sequence.count == type.sequenceLength, sequence.allSatisfy(\.isASCIIDigit) else { return nil }

        self.type = type
        self.sequence = sequence
    }

    var code: String { type.rawValue + sequence }
}
