//
//  NSObjectProtocol.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

extension NSObjectProtocol {

    func with(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }

}
