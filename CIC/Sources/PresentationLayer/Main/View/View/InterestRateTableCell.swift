//
//  InterestRateTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import PinLayout
import RxSwift

// Процентная ставка
class InterestRateTableCell: UITableViewCell {

    // MARK: - Subviews
    private let interestRateLabel = UILabel().with {
        $0.textColor = .grey
        $0.font = .systemFont(ofSize: 15)
        $0.text = "Доходность за 1 период"
    }
    private let topSeparatorView = UIView().with {
        $0.backgroundColor = UIColor.main.withAlphaComponent(0.1)
    }
    private lazy var interestRateTextField = CalculatorTextField(padding: UIEdgeInsets(equal: Margin.x(4))).with {
        $0.clearButtonMode = .whileEditing
        $0.autocorrectionType = .no
        $0.textColor = .main
        $0.font = .boldSystemFont(ofSize: 34)
        $0.keyboardType = .numberPad
        $0.text = "1"
    }
    private let bottomSeparatorView = UIView().with {
        $0.backgroundColor = UIColor.main.withAlphaComponent(0.1)
    }

    // MARK: - Properties
    var reuseBag = DisposeBag()

    // MARK: - Computed properties
    var didChangeInterestRate: Observable<String> {
        return interestRateTextField.rx.value.map { $0 ?? "0" }.asObservable()
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

        interestRateLabel.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .top(Margin.x(2))

        topSeparatorView.pin
            .horizontally()
            .height(separatorHeight)
            .above(of: interestRateTextField)

        interestRateTextField.pin
            .horizontally()
            .sizeToFit(.width)
            .below(of: interestRateLabel)
            .marginTop(Margin.x(3))

        bottomSeparatorView.pin
            .horizontally()
            .height(separatorHeight)
            .below(of: interestRateTextField)


        contentView.pin.height(bottomSeparatorView.frame.maxY + Margin.x(2))
    }

    // MARK: - Public methods
    func setup() {}

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubviews([
            interestRateLabel,
            topSeparatorView,
            interestRateTextField,
            bottomSeparatorView,
        ])
    }

}
