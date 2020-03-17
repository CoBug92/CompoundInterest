//
//  UIView+Animate.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 2/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit.UIView

extension UIView {

    func animate(completionHandler: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.curveLinear, .allowUserInteraction],
                       animations: { self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97) },
                       completion: { _ in self.inversAnimate() })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { completionHandler() }
    }

    private func inversAnimate() {
        UIView.animate(withDuration: 0.6,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 1,
        options: [.curveLinear, .allowUserInteraction],
        animations: { self.transform = .identity })
    }

}
