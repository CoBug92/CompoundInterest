//
//  MainViewModel.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine
import UIKit

final class MainViewModel {

    // MARK: - Typealiase
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<SectionType, CellType>

    // MARK: - DataSource enums
    enum SectionType: Hashable {
        case initialValue
        case keyIndicators

        var header: LabledHeaderViewModel {
            return LabledHeaderViewModel(from: Localizations.Main.keyIndicators)
        }
    }

    enum CellType: Hashable {
        case initialDeposit(InitialValueViewModel)  /// Начальный депозит
        case numberOfPeriods(InitialValueViewModel) /// Кол-во периодов
        case profitability(InitialValueViewModel)   /// Доходность за 1 период
        case monthlyIncrease(InitialValueViewModel)   /// Довложения каждый период
        case calculate
        case result(ResultViewModel)
    }

    // MARK: - Inputs
    let viewDidLoad = PassthroughSubject<Void, Never>()
    let didPressCalculate = PassthroughSubject<Void, Never>()
    let initialDeposit = CurrentValueSubject<Decimal, Never>(.zero) /// Начальный депозит
    let numberOfPeriods = CurrentValueSubject<Int, Never>(.zero) /// Кол-во периодов
    let interestRate = CurrentValueSubject<Decimal, Never>(.zero) /// Доходность за 1 период
    let monthlyIncrease = CurrentValueSubject<Decimal, Never>(.zero) /// Довложения каждый период

    // MARK: - Outputs
    @Published private(set) var dataSourceSnapshot = DataSourceSnapshot()

    // MARK: - Properties
    var result: Result?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        viewDidLoad
            .sink { [weak self] in self?.setupInitialState() }
            .store(in: &cancellables)

        didPressCalculate
            .flatMap {
                Deferred {() -> AnyPublisher<(Decimal, Int, Decimal, Decimal), Never> in
                    return Just(self.initialDeposit.value)
                        .combineLatest(
                            Just(self.numberOfPeriods.value),
                            Just(self.interestRate.value),
                            Just(self.monthlyIncrease.value)
                        ).eraseToAnyPublisher()
                }
            }
            .subscribe(on: DispatchQueue.global())
            .map { [weak self] in
                self?.calculateResult(initialDeposit: $0, numberOfPeriods: $1, interestRate: $2, monthlyIncrease: $3)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.showKeyIndicators() }
            .store(in: &cancellables)
    }

    // MARK: - Private methods
    private func setupInitialState() {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([.initialValue])
        let cells: [CellType] = [
            .initialDeposit(InitialValueViewModel(with: .initialDeposit)),
            .numberOfPeriods(InitialValueViewModel(with: .numberOfPeriods)),
            .profitability(InitialValueViewModel(with: .profitability)),
            .monthlyIncrease(InitialValueViewModel(with: .investments)),
            .calculate
        ]
        snapshot.appendItems(cells, toSection: .initialValue)
        dataSourceSnapshot = snapshot
    }

    private func showKeyIndicators() {
        guard let result = result else {
            return
        }
        if dataSourceSnapshot.sectionIdentifiers.contains(.keyIndicators) {
            dataSourceSnapshot.deleteSections([.keyIndicators])
        }
        let viewModel = ResultViewModel(with: result)
        dataSourceSnapshot.appendSections([.keyIndicators])
        dataSourceSnapshot.appendItems([.result(viewModel)], toSection: .keyIndicators)
    }

    private func calculateResult(initialDeposit: Decimal, numberOfPeriods: Int, interestRate: Decimal, monthlyIncrease: Decimal) {
        guard numberOfPeriods > 0 else {
            return
        }
        var capitalByPeriod = [Result.CapitalByPeriod]()
        var total = initialDeposit

        (0 ..< numberOfPeriods).forEach { period in
            total *= 1 + interestRate / 100
            if period != 0 { // В первый месяц кладем только начальный депозит
                total += monthlyIncrease
            }
            capitalByPeriod.append(Result.CapitalByPeriod(period: period + 1, result: total))
        }

        let decimalDepositTerm = Decimal(numberOfPeriods - 1)
        let totalDeposits = decimalDepositTerm * monthlyIncrease + initialDeposit
        let totalInterest = total - initialDeposit - (monthlyIncrease * decimalDepositTerm)
        let totalGrowth = totalInterest * 100 / initialDeposit

        self.result = Result(totalCap: total,
                             totalInterest: totalInterest,
                             totalDeposits: totalDeposits,
                             totalGrowth: totalGrowth,
                             capitalByPeriod: capitalByPeriod)
    }

}
