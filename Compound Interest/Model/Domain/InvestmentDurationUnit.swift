import Foundation

enum InvestmentDurationUnit: CaseIterable, Hashable {

    case years
    case months

    // MARK: - Computed properties

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

extension InvestmentDurationUnit {

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
}

extension InvestmentDurationUnit {

    // MARK: - Computed properties

    var storageCode: String {
        switch self {
        case .years:
            return "years"
        case .months:
            return "months"
        }
    }

    // MARK: - Init/Deinit

    init?(storageCode: String) {
        switch storageCode {
        case "years":
            self = .years
        case "months":
            self = .months
        default:
            return nil
        }
    }
}

// MARK: - Constants

private extension Decimal {
    static let monthsPerYear: Decimal = 12
}
