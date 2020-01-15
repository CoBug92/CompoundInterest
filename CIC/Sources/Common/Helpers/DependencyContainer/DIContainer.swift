//
//  DIContainer.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 12/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Dip

final class DIContainer {

    // MARK: - Init
    private init() {}

    // MARK: - Properties
    static let instance = DependencyContainer {
        unowned let container = $0

        // MARK: - Common services
        container.register { () -> [UIApplicationDelegate] in
            [
            AppearanceManager(),
            ]
        }
    }

}
