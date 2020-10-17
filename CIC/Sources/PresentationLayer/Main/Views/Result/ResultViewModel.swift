//
//  ResultViewModel.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 17.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let graphicFontSize: CGFloat = 17
    static let titleFontSize: CGFloat = 15
    static let valueFontSize: CGFloat = 24
}

private extension Double {
    static let smallKern: Double = -0.02
    static let bigKern: Double = 0.38
}

struct ResultViewModel: Hashable {

    let graphicTitle: NSAttributedString
    let totalDepositsValue: NSAttributedString
    let totalDepositsTitle: NSAttributedString
    let totalCapValue: NSAttributedString
    let totalCapTitle: NSAttributedString
    let totalInterestValue: NSAttributedString
    let totalInterestTitle: NSAttributedString
    let totalGrowthValue: NSAttributedString
    let totalGrowthTitle: NSAttributedString

    init(with result: Result) {
        graphicTitle = Localizations.Main.seeGraphic.addAttributes(font: .regular(size: .graphicFontSize),
                                                                   color: Colors.Button.third.color,
                                                                   kern: .smallKern)

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.Text.comment.color,
            .font: UIFont.regular(size: .titleFontSize),
            .kern: Double.smallKern
        ]
        totalDepositsTitle = NSAttributedString(string: Localizations.Main.contributedAmount,
                                                attributes: titleAttributes)
        totalCapTitle = NSAttributedString(string: Localizations.Main.totalCap,
                                           attributes: titleAttributes)
        totalInterestTitle = NSAttributedString(string: Localizations.Main.totalInterest,
                                                attributes: titleAttributes)
        totalGrowthTitle = NSAttributedString(string: Localizations.Main.totalGrowth,
                                              attributes: titleAttributes)

        let valueAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.Text.primary.color,
            .font: UIFont.bold(size: .valueFontSize),
            .kern: Double.bigKern
        ]
        totalDepositsValue = NSAttributedString(string: "\(result.totalDeposits.presentingPrice)" + .space + .currency,
                                                attributes: valueAttributes)
        totalInterestValue = NSAttributedString(string: "\(result.totalInterest.presentingPrice)" + .space + .currency,
                                                attributes: valueAttributes)
        totalGrowthValue = NSAttributedString(string: "\(result.totalGrowth.presentingPrice)" + .space + .persent,
                                              attributes: valueAttributes)

        totalCapValue = ("+\(result.totalCap.presentingPrice)" + .space + .currency)
            .addAttributes(font: .bold(size: .valueFontSize), color: Colors.Text.green.color, kern: .bigKern)
    }

}
