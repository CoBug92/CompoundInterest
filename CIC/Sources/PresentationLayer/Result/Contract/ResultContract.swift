//
//  ResultContract.swift
//  CIC
//
//  Created by Богдан Костюченко on 31/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

// MARK: - Builder
protocol ResultBuilderProtocol: class {
	static func build(with result: Result) -> ResultViewController
}

// MARK: - View
protocol ResultViewInput: class {
    /**
     Передача массива вью моделей
     - Parameter viewModel: Подготовленные вью модели
     - Authors: Bogdan Kostyuchenko
     */
    func setup(_ viewModels: [ResulCellType])
}
protocol ResultViewOutput {
    /**
     View была загружена
     - Authors: Bogdan Kostyuchenko
     */
    func viewDidLoad()
}

// MARK: - Interactor
protocol ResultInteractorInput {}
protocol ResultInteractorOutput: class {}

// MARK: - Router
protocol ResultRouterInput: class {}

// MARK: - Service
protocol ResultServiceProtocol {}
