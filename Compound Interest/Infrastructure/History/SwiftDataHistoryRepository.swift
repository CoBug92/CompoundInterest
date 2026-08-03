import Foundation
import SwiftData

@MainActor
final class SwiftDataHistoryRepository: HistoryRepository {

    // MARK: - Properties

    private let store: SwiftDataStore
    private let calendarProvider: () -> Calendar

    // MARK: - Init/Deinit

    init(
        store: SwiftDataStore,
        calendarProvider: @escaping () -> Calendar = {
            .history
        }
    ) {
        self.store = store
        self.calendarProvider = calendarProvider
    }

    // MARK: - Computed properties

    var isHistoryAvailable: Bool {
        true
    }

    // MARK: - Public methods

    func loadAll() throws -> [HistoryEntry] {
        let calendar = calendarProvider()
        let descriptor = FetchDescriptor<HistoryModel>(
            sortBy: [
                SortDescriptor(\HistoryModel.calculatedAt, order: .reverse),
                SortDescriptor(\HistoryModel.sequenceNumber, order: .reverse)
            ]
        )
        return try store.fetch(descriptor).compactMap {
            $0.makeEntry(calendar: calendar)
        }
    }

    func saveIfNeeded(_ input: CalculationInput, at date: Date) throws {
        let calendar = calendarProvider()
        let inputsForDay = try records(
            on: date,
            calendar: calendar
        )
        .compactMap { $0.makeEntry(calendar: calendar)?.input }
        .map(\.normalizedForHistoryComparison)
        let normalizedInput = input.normalizedForHistoryComparison

        guard !inputsForDay.contains(normalizedInput) else {
            return
        }

        store.insert(
            HistoryModel(
                calculatedAt: date,
                sequenceNumber: try nextSequenceNumber(),
                input: input
            )
        )
        try store.save()
    }

    func delete(id: UUID) throws {
        let descriptor = FetchDescriptor<HistoryModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let record = try store.fetch(descriptor).first else {
            return
        }

        store.delete(record)
        try store.save()
    }

    func deleteAll() throws {
        try store.deleteAll(HistoryModel.self)
        try store.save()
    }

    // MARK: - Private methods

    private func records(
        on date: Date,
        calendar: Calendar
    ) throws -> [HistoryModel] {
        guard let dayInterval = calendar.dateInterval(of: .day, for: date) else {
            return []
        }

        let start = dayInterval.start
        let end = dayInterval.end
        let descriptor = FetchDescriptor<HistoryModel>(
            predicate: #Predicate {
                $0.calculatedAt >= start && $0.calculatedAt < end
            }
        )
        return try store.fetch(descriptor)
    }

    private func nextSequenceNumber() throws -> Int64 {
        var descriptor = FetchDescriptor<HistoryModel>(
            sortBy: [SortDescriptor(\HistoryModel.sequenceNumber, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try store.fetch(descriptor).first.map {
            $0.sequenceNumber + 1
        } ?? .zero
    }
}
