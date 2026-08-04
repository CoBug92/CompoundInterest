import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {

    // MARK: - Observable properties

    @Published private(set) var rows: [HistoryRowViewData] = []
    @Published private(set) var errorMessage: String?

    // MARK: - Properties

    private let historyRepository: any HistoryRepository
    private let analyticsClient: any AnalyticsClient
    private let onSelect: (HistoryEntry) -> Void
    private let formatter = DecimalTextFormatter()
    private var entriesByID: [UUID: HistoryEntry] = [:]

    // MARK: - Init/Deinit

    init(
        historyRepository: any HistoryRepository,
        analyticsClient: any AnalyticsClient,
        onSelect: @escaping (HistoryEntry) -> Void
    ) {
        self.historyRepository = historyRepository
        self.analyticsClient = analyticsClient
        self.onSelect = onSelect
        reload()
    }

    // MARK: - Public methods

    func select(id: UUID) {
        guard let entry = entriesByID[id] else {
            return
        }

        onSelect(entry)
        analyticsClient.track(.historyEntryReused)
    }

    func delete(id: UUID) {
        do {
            try historyRepository.delete(id: id)
            reload()
        } catch {
            errorMessage = Localizations.History.Error.message
        }
    }

    func deleteAll() {
        do {
            try historyRepository.deleteAll()
            reload()
        } catch {
            errorMessage = Localizations.History.Error.message
        }
    }

    func clearError() {
        errorMessage = nil
    }

    // MARK: - Private methods

    private func reload() {
        do {
            let entries = try historyRepository.loadAll()
            entriesByID = Dictionary(uniqueKeysWithValues: entries.map { ($0.id, $0) })
            rows = entries.map(makeRow)
        } catch {
            errorMessage = Localizations.History.Error.message
        }
    }

    private func makeRow(for entry: HistoryEntry) -> HistoryRowViewData {
        HistoryRowViewData(
            id: entry.id,
            date: dateValue(entry.calculatedDay),
            initialInvestment: currencyValue(entry.input.initialInvestment),
            contribution: contributionValue(entry.input),
            duration: durationValue(entry.input),
            annualInterestRate: percentValue(entry.input.annualInterestRate)
        )
    }

    private func contributionValue(_ input: CalculationInput) -> String {
        let amount = input.monthlyContribution.map(currencyValue)
            ?? Localizations.History.Contribution.emptyValue
        return [amount, input.contributionFrequency.title]
            .joined(separator: .valueSeparator)
    }

    private func dateValue(_ day: HistoryDay) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        let date = calendar.date(
            from: DateComponents(year: day.year, month: day.month, day: day.day)
        ) ?? Date()
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = .gmt
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    private func durationValue(_ input: CalculationInput) -> String {
        [formatter.string(from: input.investmentDuration), input.investmentDurationUnit.title]
            .joined(separator: .space)
    }

    private func currencyValue(_ value: Decimal) -> String {
        [formatter.string(from: value), String.currencySymbol]
            .joined(separator: .nonBreakingSpace)
    }

    private func percentValue(_ value: Decimal) -> String {
        [formatter.string(from: value), String.percentSymbol]
            .joined(separator: .nonBreakingSpace)
    }
}

// MARK: - Constants

private extension String {
    static let percentSymbol = "%"
    static let valueSeparator = " · "
}
