import Foundation

extension Date {
    func anchoredToNoon(in calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self) ?? self
    }
}
