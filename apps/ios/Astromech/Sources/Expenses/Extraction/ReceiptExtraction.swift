import Foundation
import FoundationModels

@Generable(description: "Datos fiscales de una factura o recibo de la República Dominicana")
struct ReceiptExtraction {
    @Guide(description: "Nombre comercial o razón social del negocio que emitió el recibo, no del cliente")
    var businessName: String?

    @Guide(description: "RNC o cédula del negocio emisor, tal como aparece impreso")
    var rnc: String?

    @Guide(description: "Número de comprobante fiscal (NCF o e-NCF), por ejemplo B0100000123 o E310000000123")
    var ncf: String?

    @Guide(description: "Fecha de emisión del recibo tal como aparece impresa, normalmente DD/MM/AAAA")
    var invoiceDate: String?

    @Guide(description: "Subtotal antes de impuestos, en pesos dominicanos", .minimum(0))
    var subtotal: Decimal?

    @Guide(description: "Monto del ITBIS cobrado, en pesos dominicanos", .minimum(0))
    var itbis: Decimal?

    @Guide(description: "Propina legal o cargo por servicio del 10%, si aparece", .minimum(0))
    var propina: Decimal?

    @Guide(description: "Total a pagar, en pesos dominicanos", .minimum(0))
    var total: Decimal?
}
