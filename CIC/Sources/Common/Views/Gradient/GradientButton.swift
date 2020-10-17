//
//  GradientButton.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine
import SnapKit
import UIKit

private enum Constants {
    static let sizeLenght: CGFloat = 30
}

final class GradientButton: FloatingActionButton {

    // MARK: - Subviews
    private let gradientView = GradientView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview()
        addSubviewLayout()
        moveImageViewToFront()
        moveLabelViewToFront()
    }

    // MARK: - Private methods
    private func addSubview() {
        addSubview(gradientView)
    }

    private func addSubviewLayout() {
        titleLabel?.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
