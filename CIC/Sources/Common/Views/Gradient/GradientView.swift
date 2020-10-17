//
//  GradientView.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

// MARK: - Constants
private extension CGPoint {
    static let startPoint = CGPoint(x: 0, y: 0.5)
    static let endPoint = CGPoint(x: 1, y: 0.5)
}

private extension Array where Element == CGColor {
    static let colors: [CGColor] = [Colors.Button.primary.color.cgColor, Colors.Button.secondary.color.cgColor ]
}

private extension Array where Element == NSNumber {
    static let locations: [NSNumber] = [0, 1]
}

// MARK: - Implementation
final class GradientView: UIView {

    // MARK: - Properties
    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    // MARK: - Init
    init(
        withColors colors: [CGColor] = .colors,
        startPoint: CGPoint = .startPoint,
        endPoint: CGPoint = .endPoint,
        locations: [NSNumber] = .locations
    ) {
        super.init(frame: .zero)
        let gradientLayer = layer as? CAGradientLayer
        gradientLayer?.startPoint = startPoint
        gradientLayer?.locations = locations
        gradientLayer?.endPoint = endPoint
        gradientLayer?.colors = colors
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }

}
