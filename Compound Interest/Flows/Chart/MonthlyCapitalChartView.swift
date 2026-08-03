import Charts
import SwiftUI

struct MonthlyCapitalChartView: View {

    // MARK: - Typealias

    typealias MonthlyCapital = KeyIndicatorResult.MonthlyCapital

    // MARK: - Properties

    private let monthlyCapital: [MonthlyCapital]
    private let showsTitle: Bool
    private let height: CGFloat

    // MARK: - Observable properties

    @State private var selectedMonth: Int?

    // MARK: - Computed properties

    private var selectedMonthlyCapital: MonthlyCapital? {
        guard let selectedMonth else {
            return nil
        }

        return monthlyCapital.min { lhs, rhs in
            abs(lhs.month - selectedMonth) < abs(rhs.month - selectedMonth)
        }
    }

    // MARK: - Init/Deinit

    init(
        monthlyCapital: [MonthlyCapital],
        showsTitle: Bool,
        height: CGFloat
    ) {
        self.monthlyCapital = monthlyCapital
        self.showsTitle = showsTitle
        self.height = height
    }

    // MARK: - Layout

    var body: some View {
        VStack(alignment: .leading, spacing: Margin.x4) {
            if showsTitle {
                Text(verbatim: Localizations.Chart.title)
                    .font(.title3.bold())
            }

            if monthlyCapital.isEmpty {
                EmptyView()
                    .frame(height: height)
            } else {
                chartView
                    .frame(height: height)
            }
        }
    }

    private var chartView: some View {
        Chart {
            lineMarks
            selectionMarks
        }
        .chartXAxis { xAxisContent }
        .chartYAxis { yAxisContent }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text(verbatim: Localizations.Chart.Month.axis)
        }
        .chartYAxisLabel(position: .leading, alignment: .center) {
            Text(verbatim: Localizations.Chart.Capital.axis)
        }
        .chartXSelection(value: $selectedMonth)
    }

    private var lineMarks: some ChartContent {
        ForEach(monthlyCapital) { item in
            LineMark(
                x: .value(Localizations.Chart.Month.axis, item.month),
                y: .value(Localizations.Chart.Capital.axis, item.capital.doubleValue)
            )
        }
    }

    @ChartContentBuilder
    private var selectionMarks: some ChartContent {
        if let selectedMonthlyCapital {
            RuleMark(x: .value(Localizations.Chart.Month.axis, selectedMonthlyCapital.month))
                .foregroundStyle(Color(.Text.comment))
                .lineStyle(selectionLineStyle)

            PointMark(
                x: .value(Localizations.Chart.Month.axis, selectedMonthlyCapital.month),
                y: .value(Localizations.Chart.Capital.axis, selectedMonthlyCapital.capital.doubleValue)
            )
            .foregroundStyle(Color(.Text.green))
            .symbolSize(.selectedPointSize)
            .annotation(
                position: .top,
                spacing: Margin.x2,
                overflowResolution: AnnotationOverflowResolution(
                    x: .fit(to: .chart),
                    y: .fit(to: .chart)
                )
            ) {
                MonthlyCapitalChartTooltipView(
                    month: selectedMonthlyCapital.month,
                    capital: selectedMonthlyCapital.capital
                )
            }
        }
    }

    private var selectionLineStyle: StrokeStyle {
        StrokeStyle(
            lineWidth: .selectionLineWidth,
            dash: [.selectionLineDash]
        )
    }

    private var xAxisContent: some AxisContent {
        AxisMarks(position: .bottom, values: .automatic(desiredCount: .axisMarksCount)) { value in
            AxisGridLine()
            AxisTick()

            if let month = value.as(Int.self) {
                AxisValueLabel {
                    Text(verbatim: String(month))
                }
            }
        }
    }

    private var yAxisContent: some AxisContent {
        AxisMarks(position: .leading, values: .automatic(desiredCount: .axisMarksCount)) { value in
            AxisGridLine()
            AxisTick()

            if let capital = value.as(Double.self) {
                AxisValueLabel {
                    Text(verbatim: formattedCapital(capital))
                        .font(.caption2)
                }
            }
        }
    }

    // MARK: - Private methods

    private func formattedCapital(_ value: Double) -> String {
        value.formatted(.number.notation(.compactName).precision(.fractionLength(.axisFractionLength)))
    }
}

// MARK: - Constants

private extension Int {
    static let axisMarksCount: Int = 5
    static let axisFractionLength: Int = 1
}

private extension CGFloat {
    static let selectedPointSize: CGFloat = 80
    static let selectionLineDash: CGFloat = 4
    static let selectionLineWidth: CGFloat = 1
}

// MARK: - Preview

#Preview {
    MonthlyCapitalChartView(
        monthlyCapital: [
            .init(month: 1, capital: 100_000),
            .init(month: 3, capital: 116_800),
            .init(month: 6, capital: 143_250),
            .init(month: 9, capital: 171_400),
            .init(month: 12, capital: 205_680)
        ],
        showsTitle: true,
        height: 260
    )
    .padding()
}
