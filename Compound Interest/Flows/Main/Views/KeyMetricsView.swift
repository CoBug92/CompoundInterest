import SwiftUI

struct KeyMetricsView: View {

    // MARK: - Properties

    private let metrics: [KeyIndicator]

    // MARK: - Init/Deinit

    init(metrics: [KeyIndicator]) {
        self.metrics = metrics
    }

    // MARK: - Layout

    var body: some View {
        VStack(alignment: .leading, spacing: Margin.x8) {
            titleView
            contentView
        }
    }

    private var titleView: some View {
        Text(verbatim: Localizations.Metrics.Section.title)
            .font(AppFont.headline.bold())
    }

    private var contentView: some View {
        VStack(spacing: .zero) {
            metricsList
        }
        .background(
            Color(.Background.modalSecondary)
                .clipShape(.rect(cornerRadius: .cornerRadius, style: .continuous))
                .shadow(radius: .shadowRadius)
        )
    }

    private var metricsList: some View {
        VStack(spacing: .zero) {
            ForEach(Array(metrics.enumerated()), id: \.offset) { index, metric in
                KeyMetricRowView(
                    title: metric.title,
                    value: metric.value,
                    valueColor: metric.color
                )

                if index < metrics.count - .lastItemOffset {
                    Divider()
                        .foregroundStyle(Color(.separator))
                        .padding(.top, Margin.x6)
                }
            }
        }
        .padding(.horizontal, Margin.x8)
        .padding(.vertical, Margin.x4)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let cornerRadius: CGFloat = 20
    static let shadowRadius: CGFloat = 2
}

private extension Int {
    static let lastItemOffset: Int = 1
}

// MARK: - Preview

#Preview {
    KeyMetricsView(
        metrics: [
            .depositedAmount(value: 13000000),
            .totalCapital(value: 13000000),
            .earnedInterest(value: 1101613.2),
            .growthRate(value: 2301.6)
        ]
    )
}
