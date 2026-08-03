import SwiftUI

struct MainResultView: View {

    // MARK: - Properties

    let result: KeyIndicatorResult
    let keyIndicators: [KeyIndicator]

    // MARK: - Layout

    var body: some View {
        KeyMetricsView(metrics: keyIndicators)
            .transition(.keyMetricsAppearance)

        YieldChartSectionView(monthlyCapital: result.monthlyCapital)

        MonthlyCapitalListView(monthlyCapital: result.monthlyCapital)
            .transaction { transaction in
                transaction.animation = nil
            }
    }
}

// MARK: - AnyTransition

private extension AnyTransition {
    static let keyMetricsAppearance = opacity
        .combined(with: .scale(scale: .keyMetricsInitialScale, anchor: .top))
}

// MARK: - Constants

private extension CGFloat {
    static let keyMetricsInitialScale: CGFloat = 0.98
}

// MARK: - Preview

#Preview {
    MainResultView(
        result: KeyIndicatorResult(
            totalCapital: 200_000,
            earnedInterest: 50_000,
            depositedAmount: 150_000,
            growthRate: 33,
            monthlyCapital: []
        ),
        keyIndicators: []
    )
    .padding()
}
