//
//  GradientView.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

final class GradientView: UIView {

    // MARK: - Properties
    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    // MARK: - Public methods
    func configureGradientLayer(
        withColors colors: [CGColor] = [UIColor.gradient2.cgColor, UIColor.gradient1.cgColor],
        startPoint: CGPoint = CGPoint(x: 1, y: 0.3),
        endPoint: CGPoint = CGPoint(x: 0, y: 0.7),
        locations: [NSNumber] = [0.1, 1]) {

        guard let gradientLayer = layer as? CAGradientLayer else {
            return
        }
        gradientLayer.startPoint = startPoint
        gradientLayer.locations = locations
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }

}

