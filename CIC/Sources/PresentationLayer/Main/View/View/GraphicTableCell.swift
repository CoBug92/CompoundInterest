//
//  GraphicTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Charts
import PinLayout

class GraphicTableCell: UITableViewCell {

    // MARK: - Subviews
    private lazy var chartView = BarChartView().with {
        $0.drawValueAboveBarEnabled = false
        $0.chartDescription?.enabled = false
        $0.maxVisibleCount = 60
        $0.dragEnabled = true
        $0.setScaleEnabled(true)
        $0.pinchZoomEnabled = false
        $0.rightAxis.enabled = false
        $0.animate(yAxisDuration: 0.6)

        let l = $0.legend
        l.setCustom(entries: [])

        let xAxis = $0.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.labelTextColor = .main

        let leftAxis = $0.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        leftAxis.labelTextColor = .main
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)

        addSubviews()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        layout()
        return CGSize(width: frame.width, height: 300)
    }

    private func layout() {
        chartView.pin.all()
    }

    // MARK: - Public methods
    func setup(with models: [CapitalByPeriod]) {
        let yVals = models.map { BarChartDataEntry(x: Double($0.period), y: $0.result) }

        let set1 = BarChartDataSet(entries: yVals)
        set1.colors = [.gradient1]
        set1.drawValuesEnabled = false

        let data = BarChartData(dataSet: set1)
        data.setValueFont(.systemFont(ofSize: 10))
        data.barWidth = 0.9

        chartView.data = data
    }

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubview(chartView)
    }

}
