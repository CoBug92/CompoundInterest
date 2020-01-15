//
//  AppDelegate.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 10/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?
    private lazy var services: [UIApplicationDelegate] = (try? DIContainer.instance.resolve()) ?? []

    // MARK: - App
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        services.forEach {
            $0.applicationDidFinishLaunching?(application)
        }
        setupWindow()

        return true
    }

    // MARK: - Private methods
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MainBuilder.build())
        window?.makeKeyAndVisible()
    }

}

