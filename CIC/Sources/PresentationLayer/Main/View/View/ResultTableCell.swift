//
//  ResultTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import PinLayout
import RxSwift

class ResultTableCell: UITableViewCell {

    // MARK: - Subviews
    private let titleLabel = UILabel().with {
        $0.textColor = .main
        $0.font = .boldSystemFont(ofSize: 20)
        $0.text = "Ключевые показатели".localized
    }
    private let containerView = UIView().with {
        $0.backgroundColor = .darkGrey
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private let graphicButton = UIButton(type: .system).with {
        $0.setTitle("Смотреть график доходности".localized, for: .normal)
        $0.setImage(UIImage(named: "Graphic"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17)
        $0.tintColor = .gradient2
    }
    private let graphicSeparator = UIView().with {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
    private let depositsLabel = UILabel().with {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 24)
    }
    private let totalDepositsLabel = UILabel().with {
        $0.textColor = UIColor.white.withAlphaComponent(0.4)
        $0.font = .systemFont(ofSize: 15)
        $0.text = "Внесенная сумма".localized
    }
    private let totalDepositsSeparator = UIView().with {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
    private let capLabel = UILabel().with {
        $0.textColor = .green
        $0.font = .boldSystemFont(ofSize: 24)
    }
    private let totalCapLabel = UILabel().with {
        $0.textColor = UIColor.white.withAlphaComponent(0.4)
        $0.font = .systemFont(ofSize: 15)
        $0.text = "Итоговая сумма за все периоды".localized
    }
    private let totalCapSeparator = UIView().with {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
    private let interestLabel = UILabel().with {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 24)
    }
    private let totalInterestLabel = UILabel().with {
        $0.textColor = UIColor.white.withAlphaComponent(0.4)
        $0.font = .systemFont(ofSize: 15)
        $0.text = "Заработано на процентах".localized
    }
    private let totalInterestSeparator = UIView().with {
        $0.backgroundColor = UIColor.main.withAlphaComponent(0.1)
    }
    private let growthLabel = UILabel().with {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 24)
    }
    private let totalGrowthLabel = UILabel().with {
        $0.textColor = UIColor.white.withAlphaComponent(0.4)
        $0.font = .systemFont(ofSize: 15)
        $0.text = "Заработано процентов".localized
    }

    // MARK: - Computed properties
    var didPressGraphicButton: Observable<Void> {
        return graphicButton.rx.tap.asObservable()
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
        let separatorHeight: CGFloat = 1

        titleLabel.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .top(Margin.x(3))

        containerView.pin
            .horizontally(Margin.x(4))
            .below(of: titleLabel)
            .marginTop(Margin.x(3))

        graphicButton.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)

        graphicSeparator.pin
            .horizontally()
            .height(separatorHeight)
            .below(of: graphicButton)
            .marginTop(Margin.x(4))

        depositsLabel.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .below(of: graphicSeparator)
            .marginTop(Margin.x(2))

        totalDepositsLabel.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .below(of: depositsLabel)

        totalDepositsSeparator.pin
            .left(Margin.x(4))
            .right()
            .height(separatorHeight)
            .below(of: totalDepositsLabel)
            .marginTop(Margin.x(2))

        capLabel.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .below(of: totalDepositsSeparator)
            .marginTop(Margin.x(2))

        totalCapLabel.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .below(of: capLabel)

        totalCapSeparator.pin
            .left(Margin.x(4))
            .right()
            .height(separatorHeight)
            .below(of: totalCapLabel)
            .marginTop(Margin.x(2))

        interestLabel.pin
            .left(Margin.x(4))
            .right()
            .sizeToFit(.width)
            .below(of: totalCapSeparator)
            .marginTop(Margin.x(2))

        totalInterestLabel.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .below(of: interestLabel)

        totalInterestSeparator.pin
            .left(Margin.x(4))
            .right()
            .height(separatorHeight)
            .below(of: totalInterestLabel)
            .marginTop(Margin.x(2))

        growthLabel.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .below(of: totalInterestSeparator)
            .marginTop(Margin.x(2))

        totalGrowthLabel.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .below(of: growthLabel)

        containerView.pin
            .wrapContent(.vertically, padding: PEdgeInsets(verticalInset: Margin.x(4)))

        contentView.pin.height(containerView.frame.maxY + Margin.x(3))
    }

    // MARK: - Public methods
    func setup(with model: Result) {
        capLabel.text = String(format: "+ %.1f", model.totalCap)
        interestLabel.text = String(format: "%.1f", model.totalInterest)
        depositsLabel.text = String(format: "%.1f", model.totalDeposits)
        growthLabel.text = String(format: "%.1f", model.totalGrowth)
    }

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubviews([
            containerView,
            titleLabel,
        ])
        containerView.addSubviews([
            graphicButton,
            graphicSeparator,
            totalCapLabel,
            capLabel,
            totalCapSeparator,
            totalInterestLabel,
            interestLabel,
            totalInterestSeparator,
            totalDepositsLabel,
            depositsLabel,
            totalDepositsSeparator,
            totalGrowthLabel,
            growthLabel,
        ])
    }

}
