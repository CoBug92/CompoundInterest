@testable import CompoundInterest
import XCTest

@MainActor
final class HistoryViewModelAnalyticsTests: XCTestCase {

    // MARK: - Tests

    func testSelectingExistingEntryTracksReuseAfterForwardingEntry() {
        let entry = makeEntry()
        let analyticsClient = AnalyticsClientSpy()
        var selectedEntry: HistoryEntry?
        let viewModel = HistoryViewModel(
            historyRepository: InMemoryHistoryRepository(entries: [entry]),
            analyticsClient: analyticsClient,
            onSelect: { selectedEntry = $0 }
        )

        viewModel.select(id: entry.id)

        XCTAssertEqual(selectedEntry?.id, entry.id)
        XCTAssertEqual(analyticsClient.trackedEvents, [.historyEntryReused])
    }

    func testSelectingUnknownEntryDoesNotTrackReuse() {
        let analyticsClient = AnalyticsClientSpy()
        let viewModel = HistoryViewModel(
            historyRepository: InMemoryHistoryRepository(),
            analyticsClient: analyticsClient,
            onSelect: { _ in }
        )

        viewModel.select(id: UUID())

        XCTAssertTrue(analyticsClient.trackedEvents.isEmpty)
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
                monthlyContribution: nil,
                contributionFrequency: .monthly,
                investmentDuration: 10,
                investmentDurationUnit: .years,
                annualInterestRate: 12
            )
        )
    }
}
