import SwiftUI

struct OptionalDatePicker: View {
    let title: String
    @Binding var date: Date?

    var body: some View {
        if let selected = date {
            HStack {
                DatePicker(title, selection: Binding(get: { selected }, set: { date = $0 }), displayedComponents: .date)
                Button("Clear \(title)", systemImage: "xmark.circle.fill") { date = nil }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderless)
                    .frame(minWidth: 44, minHeight: 44, alignment: .trailing)
                    .contentShape(.rect)
                    .foregroundStyle(.secondary)
            }
        } else {
            LabeledContent(title) {
                Button("Add date") { date = Date.now.anchoredToNoon() }
            }
        }
    }
}

#Preview {
    @Previewable @State var date: Date?
    Form { OptionalDatePicker(title: "Date", date: $date) }
}
