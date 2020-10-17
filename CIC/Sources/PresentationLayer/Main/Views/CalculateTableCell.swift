//
//  CalculateTableCell.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 17.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine
import CombineCocoa
import UIKit

private extension CGFloat {
    static let fontSize: CGFloat = 17
    static let cornerRadius: CGFloat = 12
}

final class CalculateTableCell: UITableViewCell {

    // MARK: - Subviews
    private let calculateButton = GradientButton().with {
        $0.setTitle(Localizations.Main.calculate, for: .normal)
        $0.titleLabel?.font = UIFont.regular(size: .fontSize)
        $0.tintColor = Colors.Theme.white.color
        $0.contentEdgeInsets = UIEdgeInsets(verticalInset: Margin.x4, horizontalInset: Margin.x3)
        $0.setCorner(radius: .cornerRadius)
    }

    // MARK: - Properties
    var reuseCancellables = Set<AnyCancellable>()

    // MARK: - Computed properties
    var didPressCalculateButton: AnyPublisher<Void, Never> {
        return calculateButton.tapPublisher
            .map { [weak self] _ in self?.calculateButton.makeVibration(withStyle: .heavy) }
            .mapToVoid()
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

    // MARK: - Private methods
    private func configure() {
        contentView.backgroundColor = Colors.Background.primary.color
    }

    private func addSubviews() {
        contentView.addSubview(calculateButton)
    }

    private func addSubviewsLayout() {
        calculateButton.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview().inset(Margin.x4)
        }
    }

}
