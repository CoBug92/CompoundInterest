//
//  MainRouter.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

import UIKit

final class MainRouter {

    // MARK: - Properties
    weak var viewController: UIViewController?

}

extension MainRouter: MainRouterInput {

    func showResult(_ result: Result) {
        let viewController = ResultBuilder.build(with: result)
        self.viewController?.present(viewController, animated: true)
    }

}
