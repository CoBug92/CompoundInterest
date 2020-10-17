//
//  InitialValueTextField.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 3/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine
import CombineCocoa
import SnapKit
import UIKit

private enum Constants {
    static let infoLength: CGFloat = 20
}

final class InitialValueTextField: PaddingTextField {

    // MARK: - Subviews
    private let infoButton = UIButton(type: .infoDark).with {
        $0.tintColor = Colors.Button.primary.color
    }

    // MARK: - Properties
    var didPressInfoButton: AnyPublisher<Void, Never> {
        return infoButton.tapPublisher.mapToVoid()
    }

    // MARK: - Init
    override init(insets: UIEdgeInsets) {
        super.init(insets: insets)

        addSubview()
        addSubviewLayout()
    }

    // MARK: - Layout
    private func addSubview() {
        addSubview(infoButton)
        bringSubviewToFront(infoButton)
    }

    private func addSubviewLayout() {
        infoButton.snp.makeConstraints {
            $0.size.equalTo(Constants.infoLength)
            $0.right.equalToSuperview().inset(Margin.x8)
            $0.centerY.equalToSuperview()
        }
    }

}
