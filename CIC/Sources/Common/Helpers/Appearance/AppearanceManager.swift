//
//  AppearanceManager.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 12/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

final class AppearanceManager: NSObject {

    private func configure() {
        TableViewAppearance.configure()
        TableViewCellAppearance.configure()
        UINavigationBarAppearance.configure()
        TipsAppearance.configure()
    }

}

// MARK: - UIApplicationDelegate
extension AppearanceManager: UIApplicationDelegate {

    func applicationDidFinishLaunching(_ application: UIApplication) {
        configure()
    }

}
