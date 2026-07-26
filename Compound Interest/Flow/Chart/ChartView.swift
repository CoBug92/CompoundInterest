import Charts
import SwiftUI
import UIKit

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

    // MARK: - Properties

    private let monthlyCapital: [KeyIndicatorResult.MonthlyCapital]
    private let showsTitle: Bool
    private let height: CGFloat
    private let formatter = DecimalTextFormatter()

    // MARK: - Observable properties

    @State private var selectedMonth: Int?

    // MARK: - Computed properties

    private var selectedMonthlyCapital: KeyIndicatorResult.MonthlyCapital? {
        guard let selectedMonth else {
            return nil
        }

        return monthlyCapital.min { lhs, rhs in
            abs(lhs.month - selectedMonth) < abs(rhs.month - selectedMonth)
        }
    }

    // MARK: - Init/Deinit

    init(
        monthlyCapital: [KeyIndicatorResult.MonthlyCapital],
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
            ForEach(monthlyCapital) { item in
                LineMark(
                    x: .value(Localizations.Chart.Month.axis, item.month),
                    y: .value(Localizations.Chart.Capital.axis, item.capital.doubleValue)
                )
            }

            if let selectedMonthlyCapital {
                RuleMark(x: .value(Localizations.Chart.Month.axis, selectedMonthlyCapital.month))
                    .foregroundStyle(Color(.Text.comment))
                    .lineStyle(.init(lineWidth: .selectionLineWidth, dash: [.selectionLineDash]))

                PointMark(
                    x: .value(Localizations.Chart.Month.axis, selectedMonthlyCapital.month),
                    y: .value(Localizations.Chart.Capital.axis, selectedMonthlyCapital.capital.doubleValue)
                )
                .foregroundStyle(Color(.Text.green))
                .symbolSize(.selectedPointSize)
            }
        }
        .chartXAxis {
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
        .chartYAxis {
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

    private func tooltipView(for item: KeyIndicatorResult.MonthlyCapital) -> some View {
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
        .background(Color(.secondarySystemBackground))
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
            let firstMonth = monthlyCapital.first?.month,
            let lastMonth = monthlyCapital.last?.month
        else {
            return
        }

        let plotFrame = geometry[plotFrameAnchor]
        let xPosition = location.x - plotFrame.origin.x

        guard let rawMonth: Int = proxy.value(atX: xPosition) else {
            return
        }

        let month = min(max(rawMonth, firstMonth), lastMonth)

        guard selectedMonth != month else {
            return
        }

        selectedMonth = month
    }

    private func formattedCapital(_ value: Double) -> String {
        value.formatted(.number.notation(.compactName).precision(.fractionLength(.axisFractionLength)))
    }

    private func tooltipPosition(
        for item: KeyIndicatorResult.MonthlyCapital,
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
        let tooltipHalfWidth = min(.tooltipWidth / 2, plotFrame.width / 2)
        let tooltipHalfHeight = min(.tooltipHeight / 2, plotFrame.height / 2)

        return CGPoint(
            x: clamped(
                xCoordinate,
                lowerBound: plotFrame.minX + tooltipHalfWidth,
                upperBound: plotFrame.maxX - tooltipHalfWidth
            ),
            y: clamped(
                yCoordinate,
                lowerBound: plotFrame.minY + tooltipHalfHeight,
                upperBound: plotFrame.maxY - tooltipHalfHeight
            )
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

private struct ChartSelectionOverlay: UIViewRepresentable {

    // MARK: - Outputs

    private let onSelect: (CGPoint) -> Void

    // MARK: - Init/Deinit

    init(onSelect: @escaping (CGPoint) -> Void) {
        self.onSelect = onSelect
    }

    // MARK: - Public methods

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap)
        )

        let panGesture = UIPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePan)
        )
        panGesture.delegate = context.coordinator

        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)

        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        context.coordinator.onSelect = onSelect
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onSelect: onSelect)
    }
}

private extension ChartSelectionOverlay {

    // MARK: - Coordinator

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {

        // MARK: - Outputs

        var onSelect: (CGPoint) -> Void

        // MARK: - Init/Deinit

        init(onSelect: @escaping (CGPoint) -> Void) {
            self.onSelect = onSelect
        }

        // MARK: - Public methods

        @objc
        func handleTap(_ gesture: UITapGestureRecognizer) {
            onSelect(gesture.location(in: gesture.view))
        }

        @objc
        func handlePan(_ gesture: UIPanGestureRecognizer) {
            onSelect(gesture.location(in: gesture.view))
        }

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
                return true
            }

            let velocity = panGesture.velocity(in: panGesture.view)
            return abs(velocity.x) > abs(velocity.y)
        }
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
