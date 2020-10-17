//
//  UIEdgeInsets+Init.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    init(equal value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    init(verticalInset: CGFloat = .zero, horizontalInset: CGFloat = .zero) {
        self.init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }

}
