import Foundation

enum ContributionFrequency: CaseIterable, Hashable {

    case none
    case monthly
    case quarterly
    case yearly

    // MARK: - Public methods

    func shouldContribute(in month: Int) -> Bool {
        guard let monthInterval else {
            return false
        }

        return month.isMultiple(of: monthInterval)
    }
}

extension ContributionFrequency {

    // MARK: - Computed properties

    var storageCode: String {
        switch self {
        case .none:
            return "none"
        case .monthly:
            return "monthly"
        case .quarterly:
            return "quarterly"
        case .yearly:
            return "yearly"
        }
    }

    // MARK: - Init/Deinit

    init?(storageCode: String) {
        switch storageCode {
        case "none":
            self = .none
        case "monthly":
            self = .monthly
        case "quarterly":
            self = .quarterly
        case "yearly":
            self = .yearly
        default:
            return nil
        }
    }
}

extension ContributionFrequency {

    // MARK: - Computed properties

    var monthInterval: Int? {
        switch self {
        case .none:
            return nil
        case .monthly:
            return .monthlyInterval
        case .quarterly:
            return .quarterlyInterval
        case .yearly:
            return .yearlyInterval
        }
    }

    var title: String {
        switch self {
        case .none:
            return Localizations.Main.ContributionFrequency.None.title
        case .monthly:
            return Localizations.Main.ContributionFrequency.Monthly.title
        case .quarterly:
            return Localizations.Main.ContributionFrequency.Quarterly.title
        case .yearly:
            return Localizations.Main.ContributionFrequency.Yearly.title
        }
    }

    var contributionTitle: String {
        switch self {
        case .none:
            return Localizations.Main.Parameter.Contribution.None.title
        case .monthly:
            return Localizations.Main.Parameter.Contribution.Monthly.title
        case .quarterly:
            return Localizations.Main.Parameter.Contribution.Quarterly.title
        case .yearly:
            return Localizations.Main.Parameter.Contribution.Yearly.title
        }
    }
}

// MARK: - Constants

private extension Int {
    static let monthlyInterval: Int = 1
    static let quarterlyInterval: Int = 3
    static let yearlyInterval: Int = 12
}
