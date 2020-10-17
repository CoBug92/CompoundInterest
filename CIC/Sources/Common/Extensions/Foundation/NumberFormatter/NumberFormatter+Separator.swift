//
//  NumberFormatter+Separator.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

extension NumberFormatter {

    static let currentCurrencySymbol: String = NumberFormatter.withSpaceSeparator.currencySymbol

    static let withSpaceSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.currencyGroupingSeparator = .space
        formatter.decimalSeparator = .decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()

}
