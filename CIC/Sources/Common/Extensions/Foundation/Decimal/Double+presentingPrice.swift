//
//  Double+presentingPrice.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

extension Decimal {

    var presentingPrice: String {
        return NumberFormatter.withSpaceSeparator.string(from: self as NSNumber) ?? ""
    }

}
