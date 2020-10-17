//
//  CalculatorTextField.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

class PaddingTextField: UITextField {

    // MARK: - Properties
    private let insets: UIEdgeInsets

    // MARK: - Init
    init(insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

}
