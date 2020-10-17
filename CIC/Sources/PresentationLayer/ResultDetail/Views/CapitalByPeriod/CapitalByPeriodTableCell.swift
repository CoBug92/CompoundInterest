//
//  CapitalByPeriodTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import SnapKit
import UIKit

private extension CGFloat {
    static let cornerRadius: CGFloat = 12
    static let periodNumberFontSize: CGFloat = 12
}

final class CapitalByPeriodTableCell: UITableViewCell {

    // MARK: - Subviews
    private let containerView = UIView().with {
        $0.backgroundColor = Colors.Background.modalSecondary.color
        $0.setCorner(radius: .cornerRadius)
    }
    private let periodNumberLabel = UILabel().with {
        $0.textAlignment = .center
    }
    private let periodLabel = UILabel()
    private let totalLabel = UILabel().with {
        $0.textAlignment = .right
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        addSubviews()
        addSubviewsLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setup(with viewModel: CapitalByPeriodViewModel) {
        periodNumberLabel.attributedText = viewModel.periodNumber
        periodLabel.attributedText = viewModel.periodTitle
        totalLabel.attributedText = viewModel.total
    }

    // MARK: - Private methods
    private func configure() {
        contentView.backgroundColor = Colors.Background.modalPrimary.color
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubviews([
            periodNumberLabel,
            periodLabel,
            totalLabel,
        ])
    }

    private func addSubviewsLayout() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Margin.x3)
            $0.top.bottom.equalToSuperview().inset(Margin.x2)
        }

        totalLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Margin.x6)
            $0.top.bottom.equalToSuperview().inset(Margin.x6)
        }

        periodLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Margin.x3)
            $0.leading.equalToSuperview().inset(Margin.x4)
        }

        periodNumberLabel.snp.makeConstraints {
            $0.centerX.equalTo(periodLabel)
            $0.bottom.equalTo(periodLabel.snp.top)
        }
    }

}

extension UIStackView {

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            addArrangedSubview($0)
        }
    }

}
