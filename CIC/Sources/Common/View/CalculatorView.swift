//
//  CalculatorView.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 3/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import PinLayout
import RxSwift

class CalculatorView: UIView {

    // MARK: - Subviews
    private let titleLabel = UILabel().with {
        $0.textColor = .grey
        $0.font = .systemFont(ofSize: 15)
    }
    private let topSeparatorView = UIView().with {
        $0.backgroundColor = UIColor.main.withAlphaComponent(0.1)
    }
    private lazy var valueTextField = CalculatorTextField(padding: UIEdgeInsets(equal: Margin.x(4))).with {
        $0.clearButtonMode = .whileEditing
        $0.autocorrectionType = .no
        $0.textColor = .main
        $0.font = .boldSystemFont(ofSize: 34)
        $0.keyboardType = .numberPad
        $0.placeholder = "0"
    }
    private let bottomSeparatorView = UIView().with {
        $0.backgroundColor = UIColor.main.withAlphaComponent(0.1)
    }

    // MARK: - Properties
    var reuseBag = DisposeBag()

    // MARK: - Computed properties
    var didChangeValue: Observable<Double> {
        return valueTextField.rx.value.map { Double($0 ?? "0") ?? 0 }.asObservable()
    }
    var didPressInfoButton: Observable<Void> {
        return valueTextField.didPressInfoButton
    }

    // MARK: - Observable properties
    var titleLabelText: String = "" {
        didSet {
            titleLabel.text = titleLabelText
        }
    }
    var keyboardType: UIKeyboardType = .numberPad {
        didSet {
            valueTextField.keyboardType = keyboardType
        }
    }
    var shouldValidate: Bool = false {
        didSet {
            valueTextField.rx.value
                .skip(1)
                .subscribe(onNext: { [unowned self] in
                    let isHigher = Double($0 ?? "0") ?? 0 <= 0
                    let grey = UIColor.main.withAlphaComponent(0.1)
                    self.topSeparatorView.backgroundColor = isHigher ? .red : grey
                    self.bottomSeparatorView.backgroundColor = isHigher ? .red : grey
                })
                .disposed(by: reuseBag)
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

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
        pin.width(size.width)
        layout()
        return frame.size
    }

    private func layout() {
        let separatorHeight: CGFloat = 0.5

        titleLabel.pin
            .horizontally(Margin.x(4))
            .sizeToFit(.width)
            .top(Margin.x(2))

        topSeparatorView.pin
            .horizontally()
            .height(separatorHeight)
            .above(of: valueTextField)

        valueTextField.pin
            .horizontally()
            .sizeToFit(.width)
            .below(of: titleLabel)
            .marginTop(Margin.x(3))

        bottomSeparatorView.pin
            .horizontally()
            .height(separatorHeight)
            .below(of: valueTextField)


        pin.height(bottomSeparatorView.frame.maxY + Margin.x(2))
    }

    // MARK: - Private methods
    private func addSubviews() {
        addSubviews([
            titleLabel,
            topSeparatorView,
            valueTextField,
            bottomSeparatorView,
        ])
    }

}
