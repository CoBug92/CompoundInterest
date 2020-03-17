//
//  CalculatorTextField.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 3/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import PinLayout
import RxSwift

final class CalculatorTextField: PaddingTextField {

    // MARK: - Subviews
    private let infoButton = UIButton(type: .infoDark).with {
        $0.tintColor = .gradient1
    }

    // MARK: - Properties
    var didPressInfoButton: Observable<Void> {
        return infoButton.rx.tap.asObservable()
    }

    // MARK: - Init
    override init(padding: UIEdgeInsets) {
        super.init(padding: padding)

        addSubview(infoButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    private func layout() {
        let infoLength: CGFloat = 20

        infoButton.pin
            .size(infoLength)
            .right(Margin.x(8))
            .vCenter()
    }

}
