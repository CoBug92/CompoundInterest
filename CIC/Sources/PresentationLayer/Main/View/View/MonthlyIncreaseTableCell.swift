//
//  MonthlyIncreaseTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import PinLayout
import RxSwift

// Ежемесячная прибавка
class MonthlyIncreaseTableCell: UITableViewCell {

    // MARK: - Subviews
    private let monthlyIncreaseLabel = UILabel().with {
        $0.textColor = .grey
        $0.font = .systemFont(ofSize: 15)
        $0.text = "Довложения каждый период"
    }
    private let topSeparatorView = UIView().with {
        $0.backgroundColor = UIColor.main.withAlphaComponent(0.1)
    }
    private lazy var monthlyIncreaseTextField = CalculatorTextField(padding: UIEdgeInsets(equal: Margin.x(4))).with {
        $0.clearButtonMode = .whileEditing
        $0.autocorrectionType = .no
        $0.textColor = .main
        $0.font = .boldSystemFont(ofSize: 24)
        $0.keyboardType = .numberPad
        $0.text = "1000"
    }
    private let bottomSeparatorView = UIView().with {
        $0.backgroundColor = UIColor.main.withAlphaComponent(0.1)
    }

    // MARK: - Properties
    var reuseBag = DisposeBag()

    // MARK: - Computed properties
    var didChangeMonthlyIncrease: Observable<String> {
        return monthlyIncreaseTextField.rx.value.map { $0 ?? "0" }.asObservable()
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

        monthlyIncreaseLabel.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .top(Margin.x(2))

        topSeparatorView.pin
            .horizontally()
            .height(separatorHeight)
            .above(of: monthlyIncreaseTextField)

        monthlyIncreaseTextField.pin
            .horizontally()
            .sizeToFit(.width)
            .below(of: monthlyIncreaseLabel)
            .marginTop(Margin.x(3))

        bottomSeparatorView.pin
            .horizontally()
            .height(separatorHeight)
            .below(of: monthlyIncreaseTextField)


        contentView.pin.height(bottomSeparatorView.frame.maxY + Margin.x(2))
    }

    // MARK: - Public methods
    func setup() {}

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubviews([
            monthlyIncreaseLabel,
            topSeparatorView,
            monthlyIncreaseTextField,
            bottomSeparatorView,
        ])
    }

}
