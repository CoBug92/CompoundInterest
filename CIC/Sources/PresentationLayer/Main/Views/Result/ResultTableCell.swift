//
//  ResultTableCell.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 17.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine
import CombineCocoa
import SnapKit
import UIKit

// MARK: - Constants
private enum Constants {
    static let separatorHeight: CGFloat = 1
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 12
}

final class ResultTableCell: UITableViewCell {

    // MARK: - Subviews
    private let containerView = UIView().with {
        $0.backgroundColor = Colors.Background.modalPrimary.color
        $0.setCorner(radius: .cornerRadius)
    }
    private let graphicButton = UIButton(type: .system).with {
        $0.setImage(Images.graphic.image, for: .normal)
        $0.tintColor = Colors.Button.third.color
        $0.imageEdgeInsets.right = Margin.x3
    }
    private let graphicSeparator = UIView().with {
        $0.backgroundColor = Colors.separator.color
    }
    private let depositsLabel = UILabel()
    private let totalDepositsLabel = UILabel().with {
        $0.numberOfLines = 0
    }
    private let totalDepositsSeparator = UIView().with {
        $0.backgroundColor = Colors.separator.color
    }
    private let capLabel = UILabel()
    private let totalCapLabel = UILabel().with {
        $0.numberOfLines = 0
    }
    private let totalCapSeparator = UIView().with {
        $0.backgroundColor = Colors.separator.color
    }
    private let interestLabel = UILabel()
    private let totalInterestLabel = UILabel().with {
        $0.numberOfLines = 0
    }
    private let totalInterestSeparator = UIView().with {
        $0.backgroundColor = Colors.separator.color
    }
    private let growthLabel = UILabel()
    private let totalGrowthLabel = UILabel().with {
        $0.numberOfLines = 0
    }

    // MARK: - Properties
    var reuseCancellables = Set<AnyCancellable>()

    // MARK: - Computed properties
    var didPressGraphicButton: AnyPublisher<Void, Never> {
        return graphicButton.tapPublisher.mapToVoid()
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        addSubviews()
        addSubviewsLayout()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()

        reuseCancellables.removeAll()
    }

    // MARK: - Public methods
    func setup(with viewModel: ResultViewModel) {
        graphicButton.setAttributedTitle(viewModel.graphicTitle, for: .normal)

        depositsLabel.attributedText = viewModel.totalDepositsValue
        totalDepositsLabel.attributedText = viewModel.totalDepositsTitle

        capLabel.attributedText = viewModel.totalCapValue
        totalCapLabel.attributedText = viewModel.totalCapTitle

        interestLabel.attributedText = viewModel.totalInterestValue
        totalInterestLabel.attributedText = viewModel.totalInterestTitle

        growthLabel.attributedText = viewModel.totalGrowthValue
        totalGrowthLabel.attributedText = viewModel.totalGrowthTitle
    }

    // MARK: - Private methods
    private func configure() {
        contentView.backgroundColor = Colors.Background.primary.color
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubviews([
            graphicButton,
            graphicSeparator,
            depositsLabel,
            totalDepositsLabel,
            totalDepositsSeparator,
            totalCapLabel,
            capLabel,
            totalCapSeparator,
            totalInterestLabel,
            interestLabel,
            totalInterestSeparator,
            totalGrowthLabel,
            growthLabel,
        ])
    }

    private func addSubviewsLayout() {
        containerView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(Margin.x4)
            $0.top.bottom.equalToSuperview()
        }

        graphicButton.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(Margin.x4)
            $0.top.equalToSuperview().offset(Margin.x3)
        }

        graphicSeparator.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(Constants.separatorHeight)
            $0.top.equalTo(graphicButton.snp.bottom).offset(Margin.x3)
        }

        depositsLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(Margin.x4)
            $0.top.equalTo(graphicSeparator).offset(Margin.x2)
        }

        totalDepositsLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(Margin.x4)
            $0.top.equalTo(depositsLabel.snp.bottom).offset(Margin.x1)
        }

        totalDepositsSeparator.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(Margin.x4)
            $0.height.equalTo(Constants.separatorHeight)
            $0.top.equalTo(totalDepositsLabel.snp.bottom).offset(Margin.x2)
        }

        capLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(Margin.x4)
            $0.top.equalTo(totalDepositsSeparator.snp.bottom).offset(Margin.x2)
        }

        totalCapLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(Margin.x4)
            $0.top.equalTo(capLabel.snp.bottom).offset(Margin.x1)
        }

        totalCapSeparator.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(Margin.x4)
            $0.height.equalTo(Constants.separatorHeight)
            $0.top.equalTo(totalCapLabel.snp.bottom).offset(Margin.x2)
        }

        interestLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(Margin.x4)
            $0.top.equalTo(totalCapSeparator.snp.bottom).offset(Margin.x2)
        }

        totalInterestLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(Margin.x4)
            $0.top.equalTo(interestLabel.snp.bottom).offset(Margin.x1)
        }

        totalInterestSeparator.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(Margin.x4)
            $0.height.equalTo(Constants.separatorHeight)
            $0.top.equalTo(totalInterestLabel.snp.bottom).offset(Margin.x2)
        }

        growthLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(Margin.x4)
            $0.top.equalTo(totalInterestSeparator.snp.bottom).offset(Margin.x2)
        }

        totalGrowthLabel.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(Margin.x4)
            $0.top.equalTo(growthLabel.snp.bottom).offset(Margin.x1)
            $0.bottom.equalToSuperview().inset(Margin.x6)
        }
    }

}
