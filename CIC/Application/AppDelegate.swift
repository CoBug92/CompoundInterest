//
//  AppDelegate.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?

    // MARK: - App
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppearanceManager.configure()
        setupWindow()
        return true
    }

    // MARK: - Private methods
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewModel = MainViewModel()
        let viewController = MainViewController(with: viewModel)
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
    }

}
