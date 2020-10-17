//
//  String+Constants.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 17.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

extension String {

    static let space = " "
    static let decimalSeparator = "."
    static let persent = "%"
    static let currency = "\(NumberFormatter.currentCurrencySymbol)"

//    func getSymbol(forCurrencyCode currencyCode: String) -> String? {
//        var locale = Locale.current
//        if (locale.currencyCode != currencyCode) {
//            let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode])
//            locale = NSLocale(localeIdentifier: identifier) as Locale
//        }
//        return locale.displ
//    }

}
