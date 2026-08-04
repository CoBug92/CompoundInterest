@testable import CompoundInterest
import XCTest

final class AnalyticsEventTests: XCTestCase {

    // MARK: - Tests

    func testCalculationOutcomesHavePrivacySafeContractValues() {
        XCTAssertEqual(AnalyticsEvent.CalculationOutcome.completed.rawValue, "completed")
        XCTAssertEqual(
            AnalyticsEvent.CalculationOutcome.missingRequiredInput.rawValue,
            "missing_required_input"
        )
        XCTAssertEqual(
            AnalyticsEvent.CalculationOutcome.invalidDuration.rawValue,
            "invalid_duration"
        )
    }

    func testEventsDoNotRequireUserOrFinancialValues() {
        XCTAssertEqual(AnalyticsEvent.historyOpened, .historyOpened)
        XCTAssertEqual(AnalyticsEvent.historyEntryReused, .historyEntryReused)
        XCTAssertEqual(AnalyticsEvent.resultExportStarted, .resultExportStarted)
    }

    func testFirebasePayloadForHistoryOpenedHasNoParameters() {
        let payload = AnalyticsEvent.historyOpened.firebasePayload

        XCTAssertEqual(payload.name, .historyOpened)
        XCTAssertNil(payload.parameters)
    }

    func testFirebasePayloadForCalculationAttemptedCompletedContainsOutcome() {
        let payload = AnalyticsEvent.calculationAttempted(
            outcome: .completed
        ).firebasePayload

        XCTAssertEqual(payload.name, .calculationAttempted)
        XCTAssertEqual(payload.parameters?[.outcome] as? String, "completed")
    }

    func testFirebasePayloadForHistoryEntryReusedHasExpectedName() {
        let payload = AnalyticsEvent.historyEntryReused.firebasePayload

        XCTAssertEqual(payload.name, .historyEntryReused)
        XCTAssertNil(payload.parameters)
    }

    func testFirebasePayloadForResultExportStartedHasExpectedName() {
        let payload = AnalyticsEvent.resultExportStarted.firebasePayload

        XCTAssertEqual(payload.name, .resultExportStarted)
        XCTAssertNil(payload.parameters)
    }
}

// MARK: - Constants

private extension String {
    static let calculationAttempted = "calculation_attempted"
    static let historyEntryReused = "history_entry_reused"
    static let historyOpened = "history_opened"
    static let outcome = "outcome"
    static let resultExportStarted = "result_export_started"
}
