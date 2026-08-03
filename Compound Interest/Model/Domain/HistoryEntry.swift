import Foundation

struct HistoryEntry: Hashable, Identifiable {

    // MARK: - Properties

    let id: UUID
    let calculatedAt: Date
    let calculatedDay: HistoryDay
    let input: CalculationInput
}
