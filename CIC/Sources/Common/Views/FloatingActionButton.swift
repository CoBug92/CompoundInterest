//
//  FloatingActionButton.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine
import SnapKit
import UIKit

private extension CGFloat {
    static let xScale: CGFloat = 0.95
    static let yScale: CGFloat = 0.95
    static let zScale: CGFloat = 1
}

private extension TimeInterval {
    static let duration: TimeInterval = 0.3
}

class FloatingActionButton: UIButton {

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        bindObservable()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Binding
    private func bindObservable() {
        controlEventPublisher(for: .touchDown)
            .sink(receiveValue: { [weak self] in self?.scaleDown() })
            .store(in: &cancellables)

        controlEventPublisher(for: [.touchCancel, .touchUpInside, .touchUpOutside])
            .sink { [weak self] in self?.scaleUp() }
            .store(in: &cancellables)
    }

    // MARK: - Private methods
    private func scaleDown() {
        UIView.animate(withDuration: .duration) {
            self.layer.transform = CATransform3DMakeScale(.xScale, .yScale, .zScale)
        }
    }

    private func scaleUp() {
        UIView.animate(withDuration: .duration) {
            self.layer.transform = CATransform3DIdentity
        }
    }

}
