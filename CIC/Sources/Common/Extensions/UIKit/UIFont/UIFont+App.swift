//
//  UIFont+App.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit.UIFont

extension UIFont {

    static func regular(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .regular)
    }

    static func semibold(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .semibold)
    }

    static func bold(size: CGFloat) -> UIFont {
        return .boldSystemFont(ofSize: size)
    }

}
