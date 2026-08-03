import Foundation

struct HistoryDay: Hashable {

    // MARK: - Properties

    let year: Int
    let month: Int
    let day: Int

    // MARK: - Init/Deinit

    init(date: Date, calendar: Calendar) {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        year = components.year ?? .zero
        month = components.month ?? .zero
        day = components.day ?? .zero
    }
}
