//
//  UIView+Vibration.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 2/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit.UIView

extension UIView {

    func makeVibration(withStyle style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

}
