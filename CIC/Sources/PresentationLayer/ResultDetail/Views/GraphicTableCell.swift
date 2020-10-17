//
//  GraphicTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Charts
import SnapKit
import UIKit

// MARK: - Constants
private enum Constants {
    static let graphicHeight: CGFloat = 300
}

private extension CGFloat {
    static let xLabelFont: CGFloat = 13
    static let leftLabelFont: CGFloat = 10
    static let spaceTop: CGFloat = 0.15
}

private extension Int {
    static let maxVisibleCount = 60
    static let labelCount = 8
}

private extension TimeInterval {
    static let yAxisDuration: TimeInterval = 0.6
}

// MARK: - Implementation
final class GraphicTableCell: UITableViewCell {

    // MARK: - Subviews
    private lazy var chartView = BarChartView().with {
        $0.drawValueAboveBarEnabled = false
        $0.chartDescription?.enabled = false
        $0.maxVisibleCount = .maxVisibleCount
        $0.dragEnabled = true
        $0.setScaleEnabled(true)
        $0.pinchZoomEnabled = false
        $0.rightAxis.enabled = false
        $0.animate(yAxisDuration: .yAxisDuration)
        $0.backgroundColor = .clear

        let legend = $0.legend
        legend.setCustom(entries: [])

        let xAxis = $0.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .regular(size: .xLabelFont)
        xAxis.labelTextColor = Colors.Text.primary.color
        xAxis.drawGridLinesEnabled = false

        let leftAxis = $0.leftAxis
        leftAxis.labelFont = .regular(size: .leftLabelFont)
        leftAxis.labelCount = .labelCount
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = .spaceTop
        leftAxis.axisMinimum = .zero
        leftAxis.labelTextColor = Colors.Text.primary.color
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)

        addSubviews()
        addSubviewsLayout()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setup(with models: [Result.CapitalByPeriod]) {
        let yVals = models.map { BarChartDataEntry(x: Double($0.period), y: NSDecimalNumber(decimal: $0.result).doubleValue) }

        let set1 = BarChartDataSet(entries: yVals)
        set1.colors = [.green]
        set1.drawValuesEnabled = false
        set1.highlightAlpha = 0

        let data = BarChartData(dataSet: set1)
        data.setValueFont(.systemFont(ofSize: 10))
        data.barWidth = 0.6

        chartView.data = data
    }

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubview(chartView)
    }

    private func addSubviewsLayout() {
        chartView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(Margin.x4)
            $0.bottom.top.equalToSuperview().offset(Margin.x1)
            $0.height.equalTo(Constants.graphicHeight)
        }
    }

}
