import Charts
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

struct MonthlyCapitalChartView: View {

    // MARK: - Typealias

    typealias MonthlyCapital = KeyIndicatorResult.MonthlyCapital

    // MARK: - Properties

    private let monthlyCapital: [MonthlyCapital]
    private let showsTitle: Bool
    private let height: CGFloat
    private let formatter = DecimalTextFormatter()

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
        .chartOverlay { proxy in
            GeometryReader { geometry in
                chartOverlayContent(
                    proxy: proxy,
                    geometry: geometry
                )
            }
        }
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

    @ViewBuilder
    private func chartOverlayContent(
        proxy: ChartProxy,
        geometry: GeometryProxy
    ) -> some View {
        ZStack(alignment: .topLeading) {
            selectedTooltipView(
                proxy: proxy,
                geometry: geometry
            )

            ChartSelectionOverlay { location in
                selectMonth(
                    at: location,
                    proxy: proxy,
                    geometry: geometry
                )
            }
        }
    }

    @ViewBuilder
    private func selectedTooltipView(
        proxy: ChartProxy,
        geometry: GeometryProxy
    ) -> some View {
        if let selectedMonthlyCapital {
            tooltipView(for: selectedMonthlyCapital)
                .position(
                    tooltipPosition(
                        for: selectedMonthlyCapital,
                        proxy: proxy,
                        geometry: geometry
                    )
                )
        }
    }

    private func tooltipView(for item: MonthlyCapital) -> some View {
        VStack(alignment: .leading, spacing: Margin.x1) {
            Text(verbatim: Localizations.Chart.Selected.month(item.month))
                .font(AppFont.caption)
                .foregroundStyle(Color(.Text.comment))

            Text(verbatim: formatter.string(from: item.capital))
                .font(AppFont.caption.bold())
                .foregroundStyle(Color(.Text.primary))
        }
        .frame(width: .tooltipWidth, alignment: .leading)
        .padding(.horizontal, Margin.x3)
        .padding(.vertical, Margin.x2)
        .background(Color(.Background.modalPrimary))
        .clipShape(.rect(cornerRadius: .tooltipCornerRadius, style: .continuous))
        .shadow(radius: .tooltipShadowRadius)
    }

    // MARK: - Private methods

    private func selectMonth(
        at location: CGPoint,
        proxy: ChartProxy,
        geometry: GeometryProxy
    ) {
        guard
            let plotFrameAnchor = proxy.plotFrame,
            let monthRange = monthlyCapital.monthRange
        else {
            return
        }

        let plotFrame = geometry[plotFrameAnchor]
        let xPosition = location.x - plotFrame.origin.x

        guard let rawMonth: Int = proxy.value(atX: xPosition) else {
            return
        }

        let month = rawMonth.clamped(to: monthRange)

        guard selectedMonth != month else {
            return
        }

        selectedMonth = month
    }

    private func formattedCapital(_ value: Double) -> String {
        value.formatted(.number.notation(.compactName).precision(.fractionLength(.axisFractionLength)))
    }

    private func tooltipPosition(
        for item: MonthlyCapital,
        proxy: ChartProxy,
        geometry: GeometryProxy
    ) -> CGPoint {
        guard
            let plotFrameAnchor = proxy.plotFrame,
            let xPosition = proxy.position(forX: item.month),
            let yPosition = proxy.position(forY: item.capital.doubleValue)
        else {
            return .zero
        }

        let plotFrame = geometry[plotFrameAnchor]
        let xCoordinate = plotFrame.origin.x + xPosition
        let yCoordinate = plotFrame.origin.y + yPosition - .tooltipVerticalOffset
        let tooltipHalfSize = tooltipHalfSize(in: plotFrame)

        return CGPoint(
            x: clamped(
                xCoordinate,
                lowerBound: plotFrame.minX + tooltipHalfSize.width,
                upperBound: plotFrame.maxX - tooltipHalfSize.width
            ),
            y: clamped(
                yCoordinate,
                lowerBound: plotFrame.minY + tooltipHalfSize.height,
                upperBound: plotFrame.maxY - tooltipHalfSize.height
            )
        )
    }

    private func tooltipHalfSize(in plotFrame: CGRect) -> CGSize {
        CGSize(
            width: min(.tooltipWidth / 2, plotFrame.width / 2),
            height: min(.tooltipHeight / 2, plotFrame.height / 2)
        )
    }

    private func clamped(
        _ value: CGFloat,
        lowerBound: CGFloat,
        upperBound: CGFloat
    ) -> CGFloat {
        guard lowerBound <= upperBound else {
            return lowerBound
        }

        return min(max(value, lowerBound), upperBound)
    }
}

private extension Array where Element == KeyIndicatorResult.MonthlyCapital {

    var monthRange: ClosedRange<Int>? {
        guard let firstMonth = first?.month, let lastMonth = last?.month else {
            return nil
        }

        return firstMonth...lastMonth
    }
}

private extension Comparable {

    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - Constants

private extension Int {
    static let axisMarksCount: Int = 5
    static let axisFractionLength: Int = 1
}

private extension CGFloat {
    static let chartHeight: CGFloat = 260
    static let selectedPointSize: CGFloat = 80
    static let selectionLineDash: CGFloat = 4
    static let selectionLineWidth: CGFloat = 1
    static let tooltipCornerRadius: CGFloat = 10
    static let tooltipHeight: CGFloat = 52
    static let tooltipShadowRadius: CGFloat = 2
    static let tooltipVerticalOffset: CGFloat = 36
    static let tooltipWidth: CGFloat = 112
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
