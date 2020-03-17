//
//  MainPresenter.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

import Foundation

final class MainPresenter {

    // MARK: - Protocols properties
    weak var view: MainViewInput?
    private let router: MainRouterInput
    private let interactor: MainInteractorInput

    // MARK: - Properties
    private var result: Result?
    private var depositSize: Double = 0
    private var depositTerm: Double = 0
    private var interestRate: Double = 0
    private var monthlyIncrease: Double = 0

    // MARK: - Init
    init(interactor: MainInteractorInput, router: MainRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Private methods
    private func makeViewModels() -> [MainCellType] {
        return [
            .initialСonditions,
            .calculateButton,
            makeResultViewModel(),
            ].compactMap { $0 }
    }

    private func makeResultViewModel() -> MainCellType? {
        guard let result = result else {
            return nil
        }
        return .result(model: result)
    }

    private func calculateResult() {
        guard depositTerm > 0 else {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            var capitalByPeriod = [CapitalByPeriod]()
            var total = Double(self.depositSize)

            for period in 1 ... Int(self.depositTerm) {
                total *= 1 + self.interestRate / 100
                total += self.monthlyIncrease
                capitalByPeriod.append(CapitalByPeriod(period: period, result: total))
            }

            let totalDeposits = self.depositTerm * self.monthlyIncrease + self.depositSize
            let totalInterest = total - self.depositSize - (self.monthlyIncrease * self.depositTerm)
            let totalGrowth = (total - self.depositSize) / self.depositSize * 100

            self.result = Result(totalCap: total,
                                 totalInterest: totalInterest,
                                 totalDeposits: totalDeposits,
                                 totalGrowth: totalGrowth,
                                 capitalByPeriod: capitalByPeriod)
            DispatchQueue.main.async {
                self.view?.showData(self.makeViewModels())
            }
        }
    }

}

// MARK: - MainViewOutput
extension MainPresenter: MainViewOutput {

    func viewDidLoad() {
        view?.showData(makeViewModels())
    }

    func didPressCalculateButton() {
        calculateResult()
    }

    func didChangeDepositSize(_ depositSize: Double) {
        self.depositSize = depositSize
    }

    func didChangeDepositTerm(_ depositTerm: Double) {
        self.depositTerm = depositTerm
    }

    func didChangeInterestRate(_ interestRate: Double) {
        self.interestRate = interestRate
    }

    func didChangeMonthlyIncrease(_ monthlyIncrease: Double) {
        self.monthlyIncrease = monthlyIncrease
    }

    func didPressGraphicButton() {
        guard let result = result else {
            return
        }
        router.openResult(result)
    }

    func didPressInfo(_ infoType: InfoType) {
    }

}

// MARK: - MainInteractorOutput
extension MainPresenter: MainInteractorOutput {}
