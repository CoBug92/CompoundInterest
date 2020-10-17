//
//  ResultDetailViewModel.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 17.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine
import UIKit

final class ResultDetailViewModel {

    // MARK: - Typealiase
    typealias DataSource = (section: SectionType, cells: [CellType])

    // MARK: - DataSource enums
    enum SectionType: Hashable {

        case graphic
        case period

        var header: LabledHeaderViewModel {
            switch self {
            case .graphic:
                return LabledHeaderViewModel(from: Localizations.Detail.chart)
            case .period:
                return LabledHeaderViewModel(from: Localizations.Detail.yieldPeriod)
            }
        }
    }

    enum CellType {
        case graphic([Result.CapitalByPeriod])
        case period(CapitalByPeriodViewModel)
    }

    // MARK: - Inputs
    let viewDidLoad = PassthroughSubject<Void, Never>()

    // MARK: - Outputs
    @Published private(set) var dataSource = [DataSource]()

    // MARK: - Properties
    private let capitalByPeriod: [Result.CapitalByPeriod]
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(with capitalByPeriod: [Result.CapitalByPeriod]) {
        self.capitalByPeriod = capitalByPeriod

        viewDidLoad
            .sink { [weak self] in self?.setupInitialState() }
            .store(in: &cancellables)
    }

    // MARK: - Private methods
    private func setupInitialState() {
        dataSource = [
            (section: .graphic, cells: [.graphic(capitalByPeriod)]),
            (section: .period, cells: capitalByPeriod.map { .period(CapitalByPeriodViewModel(with: $0)) }),
        ]
    }

}
