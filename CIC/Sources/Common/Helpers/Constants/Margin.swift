//
//  Margin.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

struct Margin {

    static let x1: CGFloat = 4
    static let x2 = x1 * 2
    static let x3 = x1 * 3
    static let x4 = x1 * 4
    static let x5 = x1 * 5
    static let x6 = x1 * 6
    static let x7 = x1 * 7
    static let x8 = x1 * 8
    static let x9 = x1 * 9
    static let x10 = x1 * 10

    static func x(_ value: CGFloat) -> CGFloat {
        return 4 * value
    }

}
