//
//  InitialValueTableCell.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine
import EasyTipView
import SnapKit
import UIKit

private enum Constants {
    static let separatorHeight: CGFloat = 0.5
}

private extension CGFloat {
    static let fontSize: CGFloat = 34
}

final class InitialValueTableCell: UITableViewCell {

    // MARK: - Subviews
    private let titleLabel = UILabel()
    private let topSeparatorView = UIView().with {
        $0.backgroundColor = Colors.separator.color
    }
    private lazy var valueTextField = InitialValueTextField(insets: UIEdgeInsets(equal: Margin.x4)).with {
        $0.font = .bold(size: .fontSize)
        $0.textColor = Colors.Text.primary.color
        $0.autocorrectionType = .no
        $0.keyboardType = .numberPad
    }
    private let bottomSeparatorView = UIView().with {
        $0.backgroundColor = Colors.separator.color
    }

    // MARK: - Properties
    var reuseCancellables = Set<AnyCancellable>()

    // MARK: - Computed properties
    var didChangeValue: AnyPublisher<Decimal, Never> {
        return valueTextField.textPublisher
            .map { Decimal(string: $0?.convertCommasToDots() ?? "0") ?? .zero }
            .eraseToAnyPublisher()
    }
    var didPressInfoButton: AnyPublisher<Void, Never> {
        return valueTextField.didPressInfoButton
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
    func setup(with viewModel: InitialValueViewModel) {
        titleLabel.attributedText = viewModel.title
        valueTextField.attributedPlaceholder = viewModel.placeholder
        valueTextField.keyboardType = viewModel.keyboardType
    }

    // MARK: - Private methods
    private func configure() {
        contentView.backgroundColor = Colors.Background.primary.color
    }

    private func addSubviews() {
        contentView.addSubviews([
            titleLabel,
            topSeparatorView,
            valueTextField,
            bottomSeparatorView,
        ])
    }

    private func addSubviewsLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Margin.x4)
            $0.top.equalToSuperview().inset(Margin.x2)
        }

        topSeparatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.separatorHeight)
            $0.top.equalTo(titleLabel.snp.bottom).offset(Margin.x2)
        }

        valueTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(topSeparatorView.snp.bottom).inset(Margin.x3)
        }

        bottomSeparatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.separatorHeight)
            $0.top.equalTo(valueTextField.snp.bottom).inset(Margin.x3)
            $0.bottom.equalToSuperview().inset(Margin.x2)
        }
    }

}
