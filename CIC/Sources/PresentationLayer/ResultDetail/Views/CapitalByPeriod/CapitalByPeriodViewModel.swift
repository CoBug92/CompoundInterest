//
//  CapitalByPeriodViewModel.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 17.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

struct CapitalByPeriodViewModel {

    let periodNumber: NSAttributedString
    let periodTitle: NSAttributedString
    let total: NSAttributedString

    init(with capitalByPeriod: Result.CapitalByPeriod) {
        periodNumber = "\(capitalByPeriod.period)".addAttributes(font: .bold(size: 24),
                                                                 color: Colors.Text.primary.color,
                                                                 kern: 0.38)

        periodTitle = Localizations.Detail.month.addAttributes(font: .regular(size: 13),
                                                               color: Colors.Text.comment.color,
                                                               kern: -0.02)

        total = "\(capitalByPeriod.result.presentingPrice) ₽".addAttributes(font: .bold(size: 17),
                                                                          color: Colors.Text.primary.color,
                                                                          kern: 0.27)
    }

}
