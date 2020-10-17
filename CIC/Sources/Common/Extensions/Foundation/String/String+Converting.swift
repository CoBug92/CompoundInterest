//
//  String+Converting.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 17.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

extension String {

    func convertCommasToDots() -> String {
        return replacingOccurrences(of: ",", with: ".")
    }

}
