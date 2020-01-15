//
//  MainCellType.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

enum MainCellType: Equatable {

    case depositTerm
    case depositSize
    case interestRate
    case monthlyIncrease
    case calculateButton
    case result(model: Result)
    case graphic(models: [CapitalByPeriod])
    case capitalByPeriod(model: CapitalByPeriod)

    static func == (lhs: MainCellType, rhs: MainCellType) -> Bool {
        switch (lhs, rhs) {
        case (.calculateButton, .calculateButton),
             (.depositTerm, .depositTerm),
             (.depositSize, depositSize),
             (.interestRate, interestRate),
             (.monthlyIncrease, monthlyIncrease),
             (.result, result),
             (.graphic, graphic),
             (.capitalByPeriod, capitalByPeriod):
            return true
        default:
            return false
        }
    }

}
