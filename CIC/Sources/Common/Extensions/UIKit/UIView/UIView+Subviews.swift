//
//  UIView+Subviews.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit.UIView

extension UIView {

    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }

    func setCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

}
