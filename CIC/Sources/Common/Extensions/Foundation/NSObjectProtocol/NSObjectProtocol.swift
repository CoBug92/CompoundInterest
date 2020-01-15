//
//  NSObjectProtocol.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 10/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

extension NSObjectProtocol {

    func with(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }

}
