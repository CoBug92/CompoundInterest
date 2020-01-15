//
//  MainBuilder.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

final class MainBuilder {

    // MARK: - Init
    private init() {}

}

// MARK: - MainBuilderProtocol
extension MainBuilder: MainBuilderProtocol {

    static func build() -> MainViewController {
        let interactor = MainInteractor()
        let router = MainRouter()
        let presenter = MainPresenter(interactor: interactor, router: router)
        let viewController = MainViewController(output: presenter)

        presenter.view = viewController
        interactor.output = presenter
        router.viewController = viewController

        return viewController
    }

}
