//
//  ResultRouter.swift
//  CIC
//
//  Created by Богдан Костюченко on 31/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

import UIKit

final class ResultRouter {

    // MARK: - Properties
    weak var viewController: UIViewController?

}

extension ResultRouter: ResultRouterInput {

    func dismiss() {
        viewController?.dismiss(animated: true)
    }

}
