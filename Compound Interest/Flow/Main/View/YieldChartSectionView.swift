import SwiftUI

struct YieldChartSectionView: View {

    // MARK: - Properties

    private let monthlyCapital: [KeyIndicatorResult.MonthlyCapital]

    // MARK: - Init/Deinit

    init(monthlyCapital: [KeyIndicatorResult.MonthlyCapital]) {
        self.monthlyCapital = monthlyCapital
    }

    // MARK: - Layout

    var body: some View {
        VStack(alignment: .leading, spacing: Margin.x4) {
            titleView
            chartCard
        }
    }

    private var titleView: some View {
        Text(verbatim: Localizations.Chart.Section.title)
            .font(AppFont.headline.bold())
            .foregroundStyle(Color(.Text.primary))
    }

    private var chartCard: some View {
        MonthlyCapitalChartView(
            monthlyCapital: monthlyCapital,
            showsTitle: false,
            height: .chartHeight
        )
        .padding(.horizontal, Margin.x4)
        .padding(.top, Margin.x7)
        .padding(.bottom, Margin.x4)
        .background(cardBackground)
    }

    private var cardBackground: some View {
        Color(.secondarySystemBackground)
            .clipShape(.rect(cornerRadius: .cornerRadius, style: .continuous))
            .shadow(radius: .shadowRadius)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let chartHeight: CGFloat = 210
    static let cornerRadius: CGFloat = 20
    static let shadowRadius: CGFloat = 2
}

// MARK: - Preview

#Preview {
    YieldChartSectionView(
        monthlyCapital: [
            .init(month: 1, capital: 1000),
            .init(month: 2, capital: 1200.45),
            .init(month: 3, capital: 1450.3),
            .init(month: 4, capital: 1680.9)
        ]
    )
}
