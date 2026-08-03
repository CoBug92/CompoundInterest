import Foundation

final class InMemoryHistoryRepository: HistoryRepository {

    // MARK: - Properties

    private var entries: [HistoryEntry]

    // MARK: - Init/Deinit

    init(entries: [HistoryEntry] = []) {
        self.entries = entries
    }

    // MARK: - Computed properties

    var isHistoryAvailable: Bool {
        true
    }

    // MARK: - Public methods

    func loadAll() throws -> [HistoryEntry] {
        entries.sorted { $0.calculatedAt > $1.calculatedAt }
    }

    func saveIfNeeded(_ input: CalculationInput, at date: Date) throws {
        let calendar = Calendar.history
        let normalizedInput = input.normalizedForHistoryComparison
        let containsEquivalentInput = entries.contains {
            calendar.isDate($0.calculatedAt, inSameDayAs: date)
                && $0.input.normalizedForHistoryComparison == normalizedInput
        }

        guard !containsEquivalentInput else {
            return
        }

        entries.append(
            HistoryEntry(
                id: UUID(),
                calculatedAt: date,
                calculatedDay: HistoryDay(date: date, calendar: calendar),
                input: input
            )
        )
    }

    func delete(id: UUID) throws {
        entries.removeAll { $0.id == id }
    }

    func deleteAll() throws {
        entries.removeAll()
    }
}
