//
//  AppearanceManager.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

final class AppearanceManager {

    static func configure() {
        TableViewAppearance.configure()
        TableViewCellAppearance.configure()
        NavigationBarAppearance.configure()
        TipsAppearance.configure()
    }

}
