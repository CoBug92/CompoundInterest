//
//  DepositTermTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import PinLayout
import RxSwift

// Срок вклада
class DepositTermTableCell: UITableViewCell {

    // MARK: - Subviews
    private let depositTermLabel = UILabel().with {
        $0.textColor = .grey
        $0.font = .systemFont(ofSize: 14)
        $0.text = "Кол-во периодов"
    }
    private let topSeparatorView = UIView().with {
        $0.backgroundColor = UIColor.grey.withAlphaComponent(0.3)
    }
    private lazy var depositTermTextField = CalculatorTextField(padding: UIEdgeInsets(equal: Margin.x(4))).with {
        $0.clearButtonMode = .whileEditing
        $0.autocorrectionType = .no
        $0.textColor = .main
        $0.font = .boldSystemFont(ofSize: 24)
        $0.keyboardType = .numberPad
    }
    private let bottomSeparatorView = UIView().with {
        $0.backgroundColor = UIColor.grey.withAlphaComponent(0.3)
    }

    // MARK: - Properties
    var reuseBag = DisposeBag()

    // MARK: - Computed properties
    var didChangeDepositTerm: Observable<String> {
        return depositTermTextField.rx.value.map { $0 ?? "0" }.asObservable()
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
        let separatorHeight: CGFloat = 0.5

        depositTermLabel.pin
            .horizontally(Margin.x(3))
            .sizeToFit(.width)
            .top(Margin.x(2))

        topSeparatorView.pin
            .horizontally()
            .height(separatorHeight)
            .above(of: depositTermTextField)

        depositTermTextField.pin
            .horizontally()
            .sizeToFit(.width)
            .below(of: depositTermLabel)
            .marginTop(Margin.x(3))

        bottomSeparatorView.pin
            .horizontally()
            .height(separatorHeight)
            .below(of: depositTermTextField)


        contentView.pin.height(bottomSeparatorView.frame.maxY + Margin.x(2))
    }

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubviews([
            depositTermLabel,
            topSeparatorView,
            depositTermTextField,
            bottomSeparatorView,
        ])
    }

}
