//
//  MainContract.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

// MARK: - Builder
protocol MainBuilderProtocol: class {
	static func build() -> MainViewController
}

// MARK: - View
protocol MainViewInput: class {
    /**
     Передача массива вью моделей
     - Parameter viewModel: Подготовленные вью модели
     - Authors: Bogdan Kostyuchenko
     */
    func showData(_ viewModels: [MainCellType])
}
protocol MainViewOutput {
    /**
     View была загружена
     - Authors: Bogdan Kostyuchenko
     */
    func viewDidLoad()
    /**
     Была нажата кнопка расчета
     - Authors: Bogdan Kostyuchenko
     */
    func didPressCalculateButton()
    /**
     Вызывается каждый раз, когда пользователь обновляет доходность 1 периода
     - Authors: Bogdan Kostyuchenko
     */
    func didChangeDepositTerm(_ depositTerm: String)
    /**
     Вызывается каждый раз, когда пользователь обновляет срок вклада
     - Authors: Bogdan Kostyuchenko
     */
    func didChangeDepositSize(_ depositSize: String)
    /**
     Вызывается каждый раз, когда пользователь обновляет процентную ставку
     - Authors: Bogdan Kostyuchenko
     */
    func didChangeInterestRate(_ interestRate: String)
    /**
     Вызывается каждый раз, когда пользователь обновляет ежемесячную капитализацию
     - Authors: Bogdan Kostyuchenko
     */
    func didChangeMonthlyIncrease(_ monthlyIncrease: String)
}

// MARK: - Interactor
protocol MainInteractorInput {}
protocol MainInteractorOutput: class {}

// MARK: - Router
protocol MainRouterInput: class {}

// MARK: - Service
protocol MainServiceProtocol {}
