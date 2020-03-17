//
//  CapitalByPeriodTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import PinLayout

class CapitalByPeriodTableCell: UITableViewCell {

    // MARK: - Subviews
    private let containerView = UIView().with {
        $0.backgroundColor = UIColor.darkGrey
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private let periodNumberLabel = UILabel().with {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textColor = .white
    }
    private let periodLabel = UILabel().with {
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = UIColor.white.withAlphaComponent(0.6)
        $0.text = "Период"
    }
    private let totalLabel = UILabel().with {
        $0.textAlignment = .right
        $0.font = .boldSystemFont(ofSize: 17)
        $0.textColor = .white
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout()
        return contentView.frame.size
    }

    private func layout() {
        containerView.pin
            .horizontally(Margin.x(3))
            .top(Margin.x(2))

        periodNumberLabel.pin
            .sizeToFit()
            .left(Margin.x(7))
            .vCenter()

        periodLabel.pin
            .sizeToFit()
            .below(of: periodNumberLabel, aligned: .center)

        totalLabel.pin
            .after(of: [periodNumberLabel, periodLabel], aligned: .center)
            .right(Margin.x(Margin.x(1)))
            .sizeToFit(.width)

        containerView.pin.wrapContent(.vertically, padding: Margin.x(5))

        contentView.pin.height(containerView.frame.maxY + Margin.x(2))
    }

    // MARK: - Public methods
    func setup(with model: CapitalByPeriod) {
        periodNumberLabel.text = "\(model.period)"
        totalLabel.text = String(format: "+ %.1f %", model.result)
    }

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubviews([
            periodNumberLabel,
            periodLabel,
            totalLabel,
        ])
    }

    private func configure() {
        contentView.backgroundColor = .background
    }

}
