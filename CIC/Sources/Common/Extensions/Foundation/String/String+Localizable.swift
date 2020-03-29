//
//  String+Localizable.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 3/29/20.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

}
