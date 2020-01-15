//
//  GradientButton.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

final class GradientButton: UIButton {

    // MARK: - Subviews
    private let gradientView = GradientView().with {
        $0.configureGradientLayer()
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview()
        moveImageViewToFront()
        moveLabelViewToFront()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    private func layout() {
        let sizeLenght: CGFloat = 30

        imageView?.pin
            .size(sizeLenght)
            .right(Margin.x(3))

        titleLabel?.pin.center()

        gradientView.pin.all()
    }

    // MARK: - Private methods
    private func addSubview() {
        addSubview(gradientView)
    }

    private func moveImageViewToFront() {
        if let imageView = imageView {
            bringSubviewToFront(imageView)
        }
    }

    private func moveLabelViewToFront() {
        if let label = self.titleLabel {
            bringSubviewToFront(label)
        }
    }

}

