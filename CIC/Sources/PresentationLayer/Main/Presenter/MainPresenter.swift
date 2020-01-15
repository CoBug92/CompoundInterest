//
//  MainPresenter.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

final class MainPresenter {

    // MARK: - Protocols properties
    weak var view: MainViewInput?
    private let router: MainRouterInput
    private let interactor: MainInteractorInput

    // MARK: - Properties
    private var result: Result?
    private let monthsPerYear = 12
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
            .depositSize,
            .depositTerm,
            .interestRate,
            .monthlyIncrease,
            .calculateButton,
            makeResultViewModel(),
            makeGraphicViewModel(),
            ].compactMap { $0 } + (result?.capitalByPeriod.map { MainCellType.capitalByPeriod(model: $0) } ?? []
)
    }

    private func makeGraphicViewModel() -> MainCellType? {
        guard let result = result else {
            return nil
        }
        return .graphic(models: result.capitalByPeriod)
    }

    private func makeResultViewModel() -> MainCellType? {
        guard let result = result else {
            return nil
        }
        return .result(model: result)
    }

    private func calculate() {
        var capitalByPeriod = [CapitalByPeriod]()
        var total = Double(depositSize)

        for period in 0 ... Int(depositTerm) {
            let monthRate = interestRate / Double(monthsPerYear)
            total *= 1 + monthRate / 100
            // В первом месяце мы заносим только начальный депозит
            if period != 0 {
                total += monthlyIncrease
            }
            capitalByPeriod.append(CapitalByPeriod(period: period + 1, result: total))
        }

        let totalDeposits = depositTerm * monthlyIncrease + depositSize
        let totalInterest = total - depositSize - (monthlyIncrease * depositTerm)
        let totalGrowth = (total - depositSize) / depositSize * 100

        result = Result(totalCap: total,
                        totalInterest: totalInterest,
                        totalDeposits: totalDeposits,
                        totalGrowth: totalGrowth,
                        capitalByPeriod: capitalByPeriod)
        view?.showData(makeViewModels())
    }

}

// MARK: - MainViewOutput
extension MainPresenter: MainViewOutput {

    func viewDidLoad() {
        view?.showData(makeViewModels())
    }

    func didPressCalculateButton() {
        calculate()
    }

    func didChangeDepositSize(_ depositSize: String) {
        guard let depositSize = Double(depositSize) else {
            return
        }
        self.depositSize = depositSize
    }

    func didChangeDepositTerm(_ depositTerm: String) {
        guard let depositTerm = Double(depositTerm) else {
            return
        }
        self.depositTerm = depositTerm
    }

    func didChangeInterestRate(_ interestRate: String) {
        guard let interestRate = Double(interestRate) else {
            return
        }
        self.interestRate = interestRate
    }

    func didChangeMonthlyIncrease(_ monthlyIncrease: String) {
        guard let monthlyIncrease = Double(monthlyIncrease) else {
            return
        }
        self.monthlyIncrease = monthlyIncrease
    }

}

// MARK: - MainInteractorOutput
extension MainPresenter: MainInteractorOutput {}
