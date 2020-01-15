//
//  UIEdgeInsets+Init.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    init(equal value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    init(verticalInset: CGFloat = 0, horizontalInset: CGFloat = 0) {
        self.init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }

}
