@testable import CompoundInterest
import SwiftData
import XCTest

@MainActor
final class HistoryRepositoryTests: XCTestCase {

    // MARK: - Properties

    private let calendar = Calendar(identifier: .gregorian)

    // MARK: - Tests

    func testSaveSkipsNormalizedDuplicateOnSameDay() throws {
        let repository = try makeRepository()
        let firstDate = try makeDate(year: 2026, month: 7, day: 31, hour: 9)
        let secondDate = try makeDate(year: 2026, month: 7, day: 31, hour: 18)

        try repository.saveIfNeeded(makeInput(monthlyContribution: nil), at: firstDate)
        try repository.saveIfNeeded(makeInput(monthlyContribution: .zero), at: secondDate)

        XCTAssertEqual(try repository.loadAll().count, 1)
    }

    func testSaveKeepsSameInputOnDifferentDays() throws {
        let repository = try makeRepository()
        let firstDate = try makeDate(year: 2026, month: 7, day: 31)
        let secondDate = try makeDate(year: 2026, month: 8, day: 1)

        try repository.saveIfNeeded(makeInput(), at: firstDate)
        try repository.saveIfNeeded(makeInput(), at: secondDate)

        XCTAssertEqual(try repository.loadAll().count, 2)
    }

    func testSaveSkipsRepeatedInputAfterDifferentInputOnSameDay() throws {
        let repository = try makeRepository()
        let date = try makeDate(year: 2026, month: 7, day: 31, hour: 9)

        try repository.saveIfNeeded(makeInput(), at: date)
        try repository.saveIfNeeded(makeInput(initialInvestment: 200_000), at: date)
        try repository.saveIfNeeded(makeInput(), at: date)

        XCTAssertEqual(try repository.loadAll().count, 2)
    }

    func testInMemorySaveSkipsRepeatedInputAfterDifferentInputAtSameDate() throws {
        let repository = InMemoryHistoryRepository()
        let date = try makeDate(year: 2026, month: 7, day: 31, hour: 9)

        try repository.saveIfNeeded(makeInput(), at: date)
        try repository.saveIfNeeded(makeInput(initialInvestment: 200_000), at: date)
        try repository.saveIfNeeded(makeInput(), at: date)

        XCTAssertEqual(try repository.loadAll().count, 2)
    }

    func testLoadAllUsesInsertionOrderWhenDatesMatch() throws {
        let repository = try makeRepository()
        let date = try makeDate(year: 2026, month: 7, day: 31, hour: 9)

        try repository.saveIfNeeded(makeInput(initialInvestment: 100_000), at: date)
        try repository.saveIfNeeded(makeInput(initialInvestment: 200_000), at: date)

        XCTAssertEqual(
            try repository.loadAll().map(\.input.initialInvestment),
            [200_000, 100_000]
        )
    }

    func testNoContributionPreservesEnteredAmount() throws {
        let repository = try makeRepository()
        let input = makeInput(
            monthlyContribution: 10_000,
            contributionFrequency: .none
        )

        try repository.saveIfNeeded(input, at: Date())

        let entry = try XCTUnwrap(repository.loadAll().first)
        XCTAssertEqual(entry.input.monthlyContribution, 10_000)
    }

    func testNoContributionDeduplicatesDifferentInactiveAmounts() throws {
        let repository = try makeRepository()
        let date = try makeDate(year: 2026, month: 7, day: 31)

        try repository.saveIfNeeded(
            makeInput(monthlyContribution: 10_000, contributionFrequency: .none),
            at: date
        )
        try repository.saveIfNeeded(
            makeInput(monthlyContribution: 20_000, contributionFrequency: .none),
            at: date
        )

        XCTAssertEqual(try repository.loadAll().count, 1)
    }

    func testDeleteOneAndDeleteAll() throws {
        let repository = try makeRepository()
        try repository.saveIfNeeded(
            makeInput(),
            at: try makeDate(year: 2026, month: 7, day: 31)
        )
        try repository.saveIfNeeded(
            makeInput(initialInvestment: 200_000),
            at: try makeDate(year: 2026, month: 7, day: 31)
        )
        let firstID = try XCTUnwrap(repository.loadAll().first?.id)

        try repository.delete(id: firstID)

        XCTAssertEqual(try repository.loadAll().count, 1)

        try repository.deleteAll()

        XCTAssertTrue(try repository.loadAll().isEmpty)
    }

    // MARK: - Private methods

    private func makeRepository() throws -> SwiftDataHistoryRepository {
        let schema = Schema([HistoryModel.self])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )
        let container = try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
        return SwiftDataHistoryRepository(
            store: SwiftDataStore(container: container),
            calendarProvider: { self.calendar }
        )
    }

    private func makeInput(
        initialInvestment: Decimal = 100_000,
        monthlyContribution: Decimal? = 10_000,
        contributionFrequency: ContributionFrequency = .monthly
    ) -> CalculationInput {
        CalculationInput(
            initialInvestment: initialInvestment,
            monthlyContribution: monthlyContribution,
            contributionFrequency: contributionFrequency,
            investmentDuration: 10,
            investmentDurationUnit: .years,
            annualInterestRate: 12
        )
    }

    private func makeDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int = .zero
    ) throws -> Date {
        try XCTUnwrap(
            calendar.date(
                from: DateComponents(
                    year: year,
                    month: month,
                    day: day,
                    hour: hour
                )
            )
        )
    }
}
