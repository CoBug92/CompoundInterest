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
    private let periodLabel = UILabel()
    private let totalLabel = UILabel().with {
        $0.textAlignment = .right
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

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
        periodLabel.pin
            .sizeToFit()

        totalLabel.pin
            .after(of: periodLabel)
            .right()
            .sizeToFit(.width)
    }

    // MARK: - Public methods
    func setup(with model: CapitalByPeriod) {
        periodLabel.text = "\(model.period)"
        totalLabel.text = "\(model.result)"
    }

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubviews([
            periodLabel,
            totalLabel,
        ])
    }

}
