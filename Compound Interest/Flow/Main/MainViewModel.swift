import Foundation

final class MainViewModel: ObservableObject {

    // MARK: - Typealias

    private typealias MonthlyCapital = KeyIndicatorResult.MonthlyCapital

    // MARK: - Observable properties

    @Published var initialInvestment: Decimal? = 100000
    @Published var monthlyContribution: Decimal? = 10000
    @Published var contributionFrequency: ContributionFrequency = .monthly
    @Published var investmentDuration: Decimal? = 5
    @Published var investmentDurationUnit: InvestmentDurationUnit = .years
    @Published var annualInterestRate: Decimal? = 16
    @Published private(set) var result: KeyIndicatorResult?

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

    // MARK: - Public methods

    func calculateResult() {
        guard let input = makeInput() else {
            result = nil
            return
        }

        result = calculateResult(for: input)
    }

    // MARK: - Private methods

    private func makeInput() -> Input? {
        guard
            let initialInvestment,
            let investmentDuration,
            investmentDuration > .zero,
            let annualInterestRate
        else {
            return nil
        }

        return Input(
            initialInvestment: initialInvestment,
            contributionAmount: monthlyContribution ?? .zero,
            contributionFrequency: contributionFrequency,
            investmentDuration: investmentDuration,
            investmentDurationUnit: investmentDurationUnit,
            annualInterestRate: annualInterestRate
        )
    }

    private func calculateResult(for input: Input) -> KeyIndicatorResult {
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
}

// MARK: - Input

private extension MainViewModel {

    struct Input {

        // MARK: - Properties

        let initialInvestment: Decimal
        let contributionAmount: Decimal
        let contributionFrequency: ContributionFrequency
        let investmentDuration: Decimal
        let investmentDurationUnit: InvestmentDurationUnit
        let annualInterestRate: Decimal

        // MARK: - Computed properties

        var monthCount: Int {
            investmentDurationUnit.monthCount(from: investmentDuration)
        }

        var monthlyRate: Decimal {
            annualInterestRate / .percentScale / .monthsPerYear
        }
    }
}

// MARK: - Constants

private extension Decimal {
    static let baseGrowthFactor: Decimal = 1
    static let monthsPerYear: Decimal = 12
    static let percentScale: Decimal = 100
}
