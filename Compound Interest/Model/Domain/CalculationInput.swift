import Foundation

struct CalculationInput: Hashable {

    // MARK: - Properties

    let initialInvestment: Decimal
    let monthlyContribution: Decimal?
    let contributionFrequency: ContributionFrequency
    let investmentDuration: Decimal
    let investmentDurationUnit: InvestmentDurationUnit
    let annualInterestRate: Decimal

    // MARK: - Computed properties

    var contributionAmount: Decimal {
        guard contributionFrequency != .none else {
            return .zero
        }

        return monthlyContribution ?? .zero
    }

    var monthCount: Int {
        investmentDurationUnit.monthCount(from: investmentDuration)
    }

    var monthlyRate: Decimal {
        annualInterestRate / .percentScale / .monthsPerYear
    }

    var normalizedForHistoryComparison: CalculationInput {
        CalculationInput(
            initialInvestment: initialInvestment,
            monthlyContribution: contributionAmount,
            contributionFrequency: contributionFrequency,
            investmentDuration: investmentDuration,
            investmentDurationUnit: investmentDurationUnit,
            annualInterestRate: annualInterestRate
        )
    }
}

// MARK: - Constants

private extension Decimal {
    static let monthsPerYear: Decimal = 12
    static let percentScale: Decimal = 100
}
