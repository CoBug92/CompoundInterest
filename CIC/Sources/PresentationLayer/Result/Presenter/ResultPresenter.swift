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
    private func makeDataSet() -> [ResultDataSet] {
        return [
            makeGraphicDataSet(),
            makePeriodResultsDataSet(),
        ]
    }

    private func makeGraphicDataSet() -> ResultDataSet {
        return (.commonHeader(text: "График доходности"), [.graphic(models: result.capitalByPeriod)])
    }

    private func makePeriodResultsDataSet() -> ResultDataSet {
        return (.commonHeader(text: "Доходность по периодам"), result.capitalByPeriod.map { .period(model: $0) })
    }

}

// MARK: - ResultViewOutput
extension ResultPresenter: ResultViewOutput {

    func viewDidLoad() {
        view?.setup(makeDataSet())
    }

    func didPressCloseButton() {
        router.dismiss()
    }

}

// MARK: - ResultInteractorOutput
extension ResultPresenter: ResultInteractorOutput {}
