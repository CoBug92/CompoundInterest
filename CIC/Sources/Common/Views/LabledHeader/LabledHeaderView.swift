//
//  LabledHeaderView.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

final class LabledHeaderView: UITableViewHeaderFooterView {

    // MARK: - Subviews
    private let headerLabel = UILabel()

    // MARK: - Init / Deinit
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        configure()
        addSubviews()
        addSubviewsLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setup(with viewModel: LabledHeaderViewModel) {
        headerLabel.attributedText = viewModel.headerTitle
    }

    // MARK: - Private methods
    private func configure() {
        backgroundView = UIView()
    }

    private func addSubviews() {
        contentView.addSubview(headerLabel)
    }

    private func addSubviewsLayout() {
        headerLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().offset(Margin.x4)
            $0.centerY.equalToSuperview()
        }
    }

}
