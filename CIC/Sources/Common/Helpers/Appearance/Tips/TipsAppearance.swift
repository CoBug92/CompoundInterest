//
//  TipsAppearance.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 3/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import EasyTipView

final class TipsAppearance {

    // MARK: - Init
    private init() {}

    // MARK: - Configure
    class func configure() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = .systemFont(ofSize: 16)
        preferences.drawing.foregroundColor = .main
        preferences.drawing.backgroundColor = .gradient1
        preferences.drawing.arrowPosition = .top
        preferences.drawing.shadowColor = UIColor.black.withAlphaComponent(0.3)
        preferences.drawing.shadowRadius = 2
        EasyTipView.globalPreferences = preferences
    }

}
