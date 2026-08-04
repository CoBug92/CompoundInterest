@testable import CompoundInterest
import XCTest

@MainActor
final class MainViewModelAnalyticsTests: XCTestCase {

    // MARK: - Tests

    func testCalculationWithMissingRequiredInputTracksMissingRequiredInput() {
        let analyticsClient = AnalyticsClientSpy()
        let viewModel = makeViewModel(analyticsClient: analyticsClient)

        viewModel.calculateResult()

        XCTAssertEqual(
            analyticsClient.trackedEvents,
            [.calculationAttempted(outcome: .missingRequiredInput)]
        )
        XCTAssertNil(viewModel.result)
    }

    func testCalculationWithZeroDurationTracksInvalidDuration() {
        let analyticsClient = AnalyticsClientSpy()
        let viewModel = makeViewModel(analyticsClient: analyticsClient)
        viewModel.initialInvestment = 100_000
        viewModel.investmentDuration = .zero
        viewModel.annualInterestRate = 12

        viewModel.calculateResult()

        XCTAssertEqual(
            analyticsClient.trackedEvents,
            [.calculationAttempted(outcome: .invalidDuration)]
        )
        XCTAssertNil(viewModel.result)
    }

    func testCalculationWithNegativeDurationTracksInvalidDuration() {
        let analyticsClient = AnalyticsClientSpy()
        let viewModel = makeViewModel(analyticsClient: analyticsClient)
        viewModel.initialInvestment = 100_000
        viewModel.investmentDuration = -1
        viewModel.annualInterestRate = 12

        viewModel.calculateResult()

        XCTAssertEqual(
            analyticsClient.trackedEvents,
            [.calculationAttempted(outcome: .invalidDuration)]
        )
        XCTAssertNil(viewModel.result)
    }

    func testSuccessfulCalculationTracksCompletedWithoutChangingHistoryBehavior() throws {
        let analyticsClient = AnalyticsClientSpy()
        let repository = InMemoryHistoryRepository()
        let viewModel = MainViewModel(
            historyRepository: repository,
            analyticsClient: analyticsClient
        )
        viewModel.initialInvestment = 100_000
        viewModel.investmentDuration = 10
        viewModel.annualInterestRate = 12

        viewModel.calculateResult()

        XCTAssertEqual(
            analyticsClient.trackedEvents,
            [.calculationAttempted(outcome: .completed)]
        )
        XCTAssertNotNil(viewModel.result)
        XCTAssertEqual(try repository.loadAll().count, 1)
    }

    func testHistoryOpeningAndExportTrackOnlyExplicitIntents() {
        let analyticsClient = AnalyticsClientSpy()
        let viewModel = makeViewModel(analyticsClient: analyticsClient)

        viewModel.openHistory()
        viewModel.startResultExport()

        XCTAssertEqual(
            analyticsClient.trackedEvents,
            [.historyOpened, .resultExportStarted]
        )
    }

    // MARK: - Private methods

    private func makeViewModel(analyticsClient: AnalyticsClientSpy) -> MainViewModel {
        MainViewModel(
            historyRepository: InMemoryHistoryRepository(),
            analyticsClient: analyticsClient
        )
    }
}
