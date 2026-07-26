import Foundation

struct KeyIndicatorResult: Hashable {

    // MARK: - Properties

    let totalCapital: Decimal
    let earnedInterest: Decimal
    let depositedAmount: Decimal
    let growthRate: Decimal
    let monthlyCapital: [MonthlyCapital]

    struct MonthlyCapital: Hashable {

        // MARK: - Properties

        let month: Int
        let capital: Decimal
    }
}

// MARK: - Identifiable

extension KeyIndicatorResult.MonthlyCapital: Identifiable {

    var id: Int {
        month
    }
}
