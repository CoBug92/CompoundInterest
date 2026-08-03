@testable import CompoundInterest
import XCTest

@MainActor
final class HistoryViewModelTests: XCTestCase {

    // MARK: - Tests

    func testInitializationLoadsRepositoryEntries() {
        let entry = makeEntry()
        let viewModel = HistoryViewModel(
            historyRepository: InMemoryHistoryRepository(entries: [entry]),
            onSelect: { _ in }
        )

        XCTAssertEqual(viewModel.rows.map(\.id), [entry.id])
    }

    func testSelectionReturnsMatchingEntry() {
        let entry = makeEntry()
        var selectedEntry: HistoryEntry?
        let viewModel = HistoryViewModel(
            historyRepository: InMemoryHistoryRepository(entries: [entry]),
            onSelect: { selectedEntry = $0 }
        )

        viewModel.select(id: entry.id)

        XCTAssertEqual(selectedEntry?.id, entry.id)
    }

    func testDeletingEntryReloadsRows() throws {
        let entry = makeEntry()
        let repository = InMemoryHistoryRepository(entries: [entry])
        let viewModel = HistoryViewModel(
            historyRepository: repository,
            onSelect: { _ in }
        )

        viewModel.delete(id: entry.id)

        XCTAssertTrue(viewModel.rows.isEmpty)
        XCTAssertTrue(try repository.loadAll().isEmpty)
    }

    // MARK: - Private methods

    private func makeEntry() -> HistoryEntry {
        let date = Date(timeIntervalSince1970: 1_659_398_400)
        return HistoryEntry(
            id: UUID(),
            calculatedAt: date,
            calculatedDay: HistoryDay(date: date, calendar: .history),
            input: CalculationInput(
                initialInvestment: 100_000,
                monthlyContribution: 10_000,
                contributionFrequency: .monthly,
                investmentDuration: 10,
                investmentDurationUnit: .years,
                annualInterestRate: 12
            )
        )
    }
}
