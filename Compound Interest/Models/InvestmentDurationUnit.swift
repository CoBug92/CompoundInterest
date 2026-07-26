import Foundation

enum InvestmentDurationUnit: CaseIterable, Hashable {

    case years
    case months

    // MARK: - Computed properties

    var title: String {
        switch self {
        case .years:
            return Localizations.Main.DurationUnit.Years.title
        case .months:
            return Localizations.Main.DurationUnit.Months.title
        }
    }

    var parameterTitle: String {
        switch self {
        case .years:
            return Localizations.Main.Parameter.InvestmentYears.title
        case .months:
            return Localizations.Main.Parameter.InvestmentMonths.title
        }
    }

    var placeholder: String {
        switch self {
        case .years:
            return Localizations.Main.Parameter.InvestmentYears.placeholder
        case .months:
            return Localizations.Main.Parameter.InvestmentMonths.placeholder
        }
    }

    // MARK: - Public methods

    func monthCount(from value: Decimal) -> Int {
        switch self {
        case .years:
            return NSDecimalNumber(decimal: value * .monthsPerYear).intValue
        case .months:
            return NSDecimalNumber(decimal: value).intValue
        }
    }
}

// MARK: - Constants

private extension Decimal {
    static let monthsPerYear: Decimal = 12
}
