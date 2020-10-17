//
//  NavigationBarAppearance.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let smallFontSize: CGFloat = 17
    static let hugeFontSize: CGFloat = 34
}

enum NavigationBarAppearance {

    static func configure() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.Background.primary.color
        appearance.titleTextAttributes = [
            .font: UIFont.semibold(size: .smallFontSize),
            .foregroundColor: Colors.Text.primary.color,
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont.bold(size: .hugeFontSize),
            .foregroundColor: Colors.Text.primary.color,
        ]
        appearance.shadowColor = .clear

        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

}
