import Foundation

final class UnavailableHistoryRepository: HistoryRepository {

    // MARK: - Properties

    private let underlyingError: any Error

    // MARK: - Init/Deinit

    init(underlyingError: any Error) {
        self.underlyingError = underlyingError
    }

    // MARK: - Computed properties

    var isHistoryAvailable: Bool {
        false
    }

    // MARK: - Public methods

    func loadAll() throws -> [HistoryEntry] {
        throw underlyingError
    }

    func saveIfNeeded(_ input: CalculationInput, at date: Date) throws {
        throw underlyingError
    }

    func delete(id: UUID) throws {
        throw underlyingError
    }

    func deleteAll() throws {
        throw underlyingError
    }
}
