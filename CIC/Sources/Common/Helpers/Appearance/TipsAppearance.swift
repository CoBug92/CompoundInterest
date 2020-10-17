//
//  TipsAppearance.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 3/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import EasyTipView
import UIKit

enum TipsAppearance {

    static func configure() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = .systemFont(ofSize: 16)
        preferences.drawing.foregroundColor = Colors.Text.primary.color
        preferences.drawing.backgroundColor = Colors.Button.primary.color
        preferences.drawing.arrowPosition = .top
        preferences.drawing.shadowColor = UIColor.black.withAlphaComponent(0.3)
        preferences.drawing.shadowRadius = 2
        EasyTipView.globalPreferences = preferences
    }

}
