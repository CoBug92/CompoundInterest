//
//  ResultTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import PinLayout

class ResultTableCell: UITableViewCell {

    // MARK: - Subviews
    private let totalCapLabel = UILabel().with {
        $0.textColor = .grey
        $0.font = .systemFont(ofSize: 14)
        $0.text = "Общий капитал"
    }
    private let capLabel = UILabel().with {
        $0.textColor = .main
        $0.font = .boldSystemFont(ofSize: 24)
    }
    private let totalInterestLabel = UILabel().with {
        $0.textColor = .grey
        $0.font = .systemFont(ofSize: 14)
        $0.text = "Заработано на процентах"
    }
    private let interestLabel = UILabel().with {
        $0.textColor = .main
        $0.font = .boldSystemFont(ofSize: 24)
    }
    private let totalDepositsLabel = UILabel().with {
        $0.textColor = .grey
        $0.font = .systemFont(ofSize: 14)
        $0.text = "Вложений"
    }
    private let depositsLabel = UILabel().with {
        $0.textColor = .main
        $0.font = .boldSystemFont(ofSize: 24)
    }
    private let totalGrowthLabel = UILabel().with {
        $0.textColor = .grey
        $0.font = .systemFont(ofSize: 14)
        $0.text = "Заработано процентов"
    }
    private let growthLabel = UILabel().with {
        $0.textColor = .main
        $0.font = .boldSystemFont(ofSize: 24)
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
        totalCapLabel.pin
            .horizontally(Margin.x(3))
            .sizeToFit(.width)
            .top(Margin.x(3))

        capLabel.pin
            .horizontally(Margin.x(3))
            .sizeToFit(.width)
            .below(of: totalCapLabel)
            .marginTop(Margin.x(2))

        totalInterestLabel.pin
            .horizontally(Margin.x(3))
            .sizeToFit(.width)
            .below(of: capLabel)
            .marginTop(Margin.x(4))

        interestLabel.pin
            .horizontally(Margin.x(3))
            .sizeToFit(.width)
            .below(of: totalInterestLabel)
            .marginTop(Margin.x(2))

        totalDepositsLabel.pin
            .horizontally(Margin.x(3))
            .sizeToFit(.width)
            .below(of: interestLabel)
            .marginTop(Margin.x(4))

        depositsLabel.pin
            .horizontally(Margin.x(3))
            .sizeToFit(.width)
            .below(of: totalDepositsLabel)
            .marginTop(Margin.x(2))

        totalGrowthLabel.pin
            .horizontally(Margin.x(3))
            .sizeToFit(.width)
            .below(of: depositsLabel)
            .marginTop(Margin.x(4))

        growthLabel.pin
            .horizontally(Margin.x(3))
            .sizeToFit(.width)
            .below(of: totalGrowthLabel)
            .marginTop(Margin.x(2))

        contentView.pin.height(growthLabel.frame.maxY + Margin.x(3))
    }

    // MARK: - Public methods
    func setup(with model: Result) {
        capLabel.text = String(format: "%.1f", model.totalCap)
        interestLabel.text = String(format: "%.1f", model.totalInterest)
        depositsLabel.text = String(format: "%.1f", model.totalDeposits)
        growthLabel.text = String(format: "%.1f", model.totalGrowth)
    }

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubviews([
            totalCapLabel,
            capLabel,
            totalInterestLabel,
            interestLabel,
            totalDepositsLabel,
            depositsLabel,
            totalGrowthLabel,
            growthLabel,
        ])
    }

}
