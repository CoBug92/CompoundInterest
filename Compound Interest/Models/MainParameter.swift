import Foundation

enum MainParameter: CaseIterable {

    case initialInvestment
    case monthlyContribution
    case investmentDuration
    case annualInterestRate

    // MARK: - Computed properties

    var title: String {
        switch self {
        case .initialInvestment:
            return Localizations.Main.Parameter.InitialInvestment.title
        case .monthlyContribution:
            return Localizations.Main.Parameter.MonthlyContribution.title
        case .investmentDuration:
            return Localizations.Main.Parameter.InvestmentYears.title
        case .annualInterestRate:
            return Localizations.Main.Parameter.AnnualInterestRate.title
        }
    }

    var placeholder: String {
        switch self {
        case .initialInvestment:
            return Localizations.Main.Parameter.InitialInvestment.placeholder
        case .monthlyContribution:
            return Localizations.Main.Parameter.MonthlyContribution.placeholder
        case .investmentDuration:
            return Localizations.Main.Parameter.InvestmentYears.placeholder
        case .annualInterestRate:
            return Localizations.Main.Parameter.AnnualInterestRate.placeholder
        }
    }

    var suffix: String {
        switch self {
        case .initialInvestment, .monthlyContribution:
            return .currencySymbol
        case .investmentDuration:
            return .empty
        case .annualInterestRate:
            return .percentSymbol
        }
    }

    var hint: String {
        switch self {
        case .initialInvestment:
            return Localizations.Main.Parameter.InitialInvestment.hint
        case .monthlyContribution:
            return Localizations.Main.Parameter.MonthlyContribution.hint
        case .investmentDuration:
            return Localizations.Main.Parameter.InvestmentYears.hint
        case .annualInterestRate:
            return Localizations.Main.Parameter.AnnualInterestRate.hint
        }
    }
}

// MARK: - Constants

private extension String {
    static let percentSymbol = "%"
}
