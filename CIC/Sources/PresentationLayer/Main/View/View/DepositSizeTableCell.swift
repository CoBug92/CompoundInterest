//
//  DepositSizeTableCell.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import PinLayout
import RxSwift

// Размер вклада
class DepositSizeTextField: UITableViewCell {

    // MARK: - Subviews
    private let depositSizeLabel = UILabel().with {
        $0.textColor = .grey
        $0.font = .systemFont(ofSize: 14)
        $0.text = "Начальный депозит"
    }
    private let topSeparatorView = UIView().with {
        $0.backgroundColor = UIColor.grey.withAlphaComponent(0.3)
    }
    private lazy var depositSizeTextField = CalculatorTextField(padding: UIEdgeInsets(equal: Margin.x(4))).with {
        $0.delegate = self
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
    private let didChangeDepositSizeSubject = PublishSubject<String>()

    // MARK: - Computed properties
    var didChangeDepositSize: Observable<String> {
        return didChangeDepositSizeSubject.asObservable()
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

        depositSizeLabel.pin
            .horizontally(Margin.x(3))
            .sizeToFit(.width)
            .top(Margin.x(2))

        topSeparatorView.pin
            .horizontally()
            .height(separatorHeight)
            .above(of: depositSizeTextField)

        depositSizeTextField.pin
            .horizontally()
            .sizeToFit(.width)
            .below(of: depositSizeLabel)
            .marginTop(Margin.x(3))

        bottomSeparatorView.pin
            .horizontally()
            .height(separatorHeight)
            .below(of: depositSizeTextField)


        contentView.pin.height(bottomSeparatorView.frame.maxY + Margin.x(2))
    }

    // MARK: - Private methods
    private func addSubviews() {
        contentView.addSubviews([
            depositSizeLabel,
            topSeparatorView,
            depositSizeTextField,
            bottomSeparatorView,
        ])
    }

}

extension DepositSizeTextField: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        didChangeDepositSizeSubject.onNext(text + string)
        return true
    }

}
