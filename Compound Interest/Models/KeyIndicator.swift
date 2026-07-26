import Foundation

enum KeyIndicator: Hashable {

    case depositedAmount(value: Decimal)
    case totalCapital(value: Decimal)
    case earnedInterest(value: Decimal)
    case growthRate(value: Decimal)

    // MARK: - Computed properties

    var title: String {
        switch self {
        case .depositedAmount:
            return Localizations.Metrics.DepositedAmount.title
        case .totalCapital:
            return Localizations.Metrics.TotalCapital.title
        case .earnedInterest:
            return Localizations.Metrics.EarnedInterest.title
        case .growthRate:
            return Localizations.Metrics.GrowthRate.title
        }
    }

    var value: Decimal {
        switch self {
        case let .depositedAmount(value),
             let .totalCapital(value),
             let .earnedInterest(value),
             let .growthRate(value):
            return value
        }
    }
}
