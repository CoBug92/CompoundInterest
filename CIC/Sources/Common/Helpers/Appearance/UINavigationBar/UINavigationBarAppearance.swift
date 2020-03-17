//
//  UINavigationBarAppearance.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 3/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

final class UINavigationBarAppearance {

    // MARK: - Init
    private init() {}

    // MARK: - Configure
    class func configure() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.main]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.main]
        UINavigationBar.appearance().barTintColor = .background
        UINavigationBar.appearance().isOpaque = false
        UINavigationBar.appearance().prefersLargeTitles = true
    }

}
