//
//  ResultBuilder.swift
//  CIC
//
//  Created by Богдан Костюченко on 31/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

final class ResultBuilder: ResultBuilderProtocol {

    static func build(with result: Result) -> ResultViewController {
        let interactor = ResultInteractor()
        let router = ResultRouter()
        let presenter = ResultPresenter(interactor: interactor, router: router, result: result)
        let viewController = ResultViewController(output: presenter)

        presenter.view = viewController
        interactor.output = presenter
        router.viewController = viewController

        return viewController
    }

}
