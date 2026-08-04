import Foundation

@MainActor
final class MainViewModel: ObservableObject {

    // MARK: - Typealias

    private typealias MonthlyCapital = KeyIndicatorResult.MonthlyCapital

    // MARK: - Observable properties

    @Published var initialInvestment: Decimal?
    @Published var monthlyContribution: Decimal?
    @Published var contributionFrequency: ContributionFrequency = .monthly
    @Published var investmentDuration: Decimal?
    @Published var investmentDurationUnit: InvestmentDurationUnit = .years
    @Published var annualInterestRate: Decimal?
    @Published private(set) var result: KeyIndicatorResult?
    @Published private(set) var historyErrorMessage: String?

    // MARK: - Properties

    private let historyRepository: any HistoryRepository
    private let analyticsClient: any AnalyticsClient

    // MARK: - Init/Deinit

    init(
        historyRepository: any HistoryRepository,
        analyticsClient: any AnalyticsClient
    ) {
        self.historyRepository = historyRepository
        self.analyticsClient = analyticsClient
        if !historyRepository.isHistoryAvailable {
            historyErrorMessage = Localizations.History.Error.message
        }
    }

    // MARK: - Computed properties

    var keyIndicators: [KeyIndicator] {
        guard let result else {
            return []
        }

        return [
            .depositedAmount(value: result.depositedAmount),
            .totalCapital(value: result.totalCapital),
            .earnedInterest(value: result.earnedInterest),
            .growthRate(value: result.growthRate)
        ]
    }

    var isHistoryAvailable: Bool {
        historyRepository.isHistoryAvailable
    }

    // MARK: - Public methods

    func calculateResult() {
        switch makeInput() {
        case .missingRequiredInput:
            analyticsClient.track(.calculationAttempted(outcome: .missingRequiredInput))
            result = nil
        case .invalidDuration:
            analyticsClient.track(.calculationAttempted(outcome: .invalidDuration))
            result = nil
        case let .valid(input):
            analyticsClient.track(.calculationAttempted(outcome: .completed))
            result = calculateResult(for: input)
            saveToHistory(input)
        }
    }

    func applyHistoryEntry(_ entry: HistoryEntry) {
        initialInvestment = entry.input.initialInvestment
        monthlyContribution = entry.input.monthlyContribution
        contributionFrequency = entry.input.contributionFrequency
        investmentDuration = entry.input.investmentDuration
        investmentDurationUnit = entry.input.investmentDurationUnit
        annualInterestRate = entry.input.annualInterestRate
        result = nil
    }

    func clearHistoryError() {
        historyErrorMessage = nil
    }

    func makeHistoryViewModel() -> HistoryViewModel {
        HistoryViewModel(
            historyRepository: historyRepository,
            analyticsClient: analyticsClient,
            onSelect: applyHistoryEntry
        )
    }

    func openHistory() {
        analyticsClient.track(.historyOpened)
    }

    func startResultExport() {
        analyticsClient.track(.resultExportStarted)
    }

    // MARK: - Private methods

    private func makeInput() -> CalculationInputState {
        guard
            let initialInvestment,
            let investmentDuration,
            let annualInterestRate
        else {
            return .missingRequiredInput
        }

        guard investmentDuration > .zero else {
            return .invalidDuration
        }

        return .valid(CalculationInput(
            initialInvestment: initialInvestment,
            monthlyContribution: monthlyContribution,
            contributionFrequency: contributionFrequency,
            investmentDuration: investmentDuration,
            investmentDurationUnit: investmentDurationUnit,
            annualInterestRate: annualInterestRate
        ))
    }

    private func calculateResult(for input: CalculationInput) -> KeyIndicatorResult {
        let monthCount = input.monthCount
        let monthlyRate = input.monthlyRate
        let monthlyGrowthFactor = .baseGrowthFactor + monthlyRate

        var capital = input.initialInvestment
        var depositedAmount = input.initialInvestment
        var monthlyCapital: [MonthlyCapital] = []

        guard monthCount > .zero else {
            return makeResult(
                totalCapital: capital,
                depositedAmount: depositedAmount,
                monthlyCapital: monthlyCapital
            )
        }

        for month in 1...monthCount {
            capital *= monthlyGrowthFactor

            if input.contributionFrequency.shouldContribute(in: month) {
                capital += input.contributionAmount
                depositedAmount += input.contributionAmount
            }

            monthlyCapital.append(
                MonthlyCapital(
                    month: month,
                    capital: capital
                )
            )
        }

        return makeResult(
            totalCapital: capital,
            depositedAmount: depositedAmount,
            monthlyCapital: monthlyCapital
        )
    }

    private func makeResult(
        totalCapital: Decimal,
        depositedAmount: Decimal,
        monthlyCapital: [MonthlyCapital]
    ) -> KeyIndicatorResult {
        let earnedInterest = totalCapital - depositedAmount
        let growthRate = makeGrowthRate(
            earnedInterest: earnedInterest,
            depositedAmount: depositedAmount
        )

        return KeyIndicatorResult(
            totalCapital: totalCapital,
            earnedInterest: earnedInterest,
            depositedAmount: depositedAmount,
            growthRate: growthRate,
            monthlyCapital: monthlyCapital
        )
    }

    private func makeGrowthRate(
        earnedInterest: Decimal,
        depositedAmount: Decimal
    ) -> Decimal {
        guard depositedAmount != .zero else {
            return .zero
        }

        return earnedInterest * .percentScale / depositedAmount
    }

    private func saveToHistory(_ input: CalculationInput) {
        do {
            try historyRepository.saveIfNeeded(input, at: Date())
        } catch {
            historyErrorMessage = Localizations.History.Error.message
        }
    }
}

private enum CalculationInputState {
    case missingRequiredInput
    case invalidDuration
    case valid(CalculationInput)
}

// MARK: - Constants

private extension Decimal {
    static let baseGrowthFactor: Decimal = 1
    static let percentScale: Decimal = 100
}
