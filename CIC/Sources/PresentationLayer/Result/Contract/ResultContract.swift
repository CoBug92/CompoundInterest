//
//  ResultContract.swift
//  CIC
//
//  Created by Богдан Костюченко on 31/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

// MARK: - Typealiase
typealias ResultDataSet = (section: ResultSectionType, cells: [ResulCellType])

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
    func setup(_ viewModels: [ResultDataSet])
}
protocol ResultViewOutput {
    /**
     View была загружена
     - Authors: Bogdan Kostyuchenko
     */
    func viewDidLoad()
    func didPressCloseButton()
}

// MARK: - Interactor
protocol ResultInteractorInput {}
protocol ResultInteractorOutput: class {}

// MARK: - Router
protocol ResultRouterInput: class {
    func dismiss()
}

// MARK: - Service
protocol ResultServiceProtocol {}
