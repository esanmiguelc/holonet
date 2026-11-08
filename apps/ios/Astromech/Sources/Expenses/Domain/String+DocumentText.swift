import Foundation

extension Character {
    var isASCIIDigit: Bool { isASCII && isNumber }
}

extension String {
    var removingDocumentSeparators: String {
        filter { $0 != "-" && !$0.isWhitespace }
    }

    func grouped(by groupSizes: [Int], separator: String = "-") -> String {
        var remainder = Substring(self)
        let groups = groupSizes.map { size in
            let group = remainder.prefix(size)
            remainder = remainder.dropFirst(size)
            return String(group)
        }
        return groups.joined(separator: separator)
    }
}
