//
//  Result.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

struct Result {

    let totalCap: Decimal
    let totalInterest: Decimal
    let totalDeposits: Decimal
    let totalGrowth: Decimal
    let capitalByPeriod: [CapitalByPeriod]

    struct CapitalByPeriod {

        let period: Int
        let result: Decimal

    }

}
