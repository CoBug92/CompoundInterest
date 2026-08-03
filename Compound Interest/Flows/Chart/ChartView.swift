import SwiftUI

struct ChartView: View {

    // MARK: - Typealias

    private typealias MonthlyCapital = KeyIndicatorResult.MonthlyCapital

    // MARK: - Properties

    private let monthlyCapital: [MonthlyCapital]

    // MARK: - Init/Deinit

    init(result: KeyIndicatorResult) {
        monthlyCapital = result.monthlyCapital
    }

    // MARK: - Layout

    var body: some View {
        MonthlyCapitalChartView(
            monthlyCapital: monthlyCapital,
            showsTitle: true,
            height: .chartHeight
        )
        .padding(.horizontal, Margin.x5)
        .padding(.vertical, Margin.x4)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let chartHeight: CGFloat = 260
}

// MARK: - Preview

#Preview {
    ChartView(
        result: KeyIndicatorResult(
            totalCapital: 1000,
            earnedInterest: 100,
            depositedAmount: 10000,
            growthRate: 10,
            monthlyCapital: [
                .init(month: 1, capital: 1000),
                .init(month: 2, capital: 1200.45),
                .init(month: 3, capital: 1450.3),
                .init(month: 4, capital: 1680.9)
            ]
        )
    )
}
