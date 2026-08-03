import Foundation

extension Calendar {

    // MARK: - Computed properties

    static var history: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        return calendar
    }
}
