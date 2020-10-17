//
//  String+AttributedString.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

extension String {

    func addAttributes(font: UIFont, color: UIColor?, kern: Double = 0) -> NSAttributedString {
        NSAttributedString(string: self, attributes: attributes(font: font, color: color, kern: kern))
    }

    private func attributes(font: UIFont, color: UIColor?, kern: Double) -> [NSAttributedString.Key: Any] {
        return [
            .font: font,
            .foregroundColor: color as Any,
            .kern: kern
        ]
    }

}
