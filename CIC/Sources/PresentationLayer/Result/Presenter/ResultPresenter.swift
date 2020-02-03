//
//  ResultPresenter.swift
//  CIC
//
//  Created by Богдан Костюченко on 31/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

final class ResultPresenter {

    // MARK: - Protocols properties
    weak var view: ResultViewInput?
    private let router: ResultRouterInput
    private let interactor: ResultInteractorInput

    // MARK: - Properties
    private let result: Result

    // MARK: - Init
    init(interactor: ResultInteractorInput, router: ResultRouterInput, result: Result) {
        self.interactor = interactor
        self.router = router
        self.result = result
    }

    // MARK: - Private methods
    private func makeViewModel() -> [ResulCellType] {
        return [.graphic(models: result.capitalByPeriod)] + result.capitalByPeriod.map { .period(model: $0) }
    }

}

// MARK: - ResultViewOutput
extension ResultPresenter: ResultViewOutput {

    func viewDidLoad() {
        view?.setup(makeViewModel())
    }

}

// MARK: - ResultInteractorOutput
extension ResultPresenter: ResultInteractorOutput {}
