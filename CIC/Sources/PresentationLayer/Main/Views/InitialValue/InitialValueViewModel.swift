//
//  InitialValueViewModel.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 17.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let titleFontSize: CGFloat = 15
    static let valueFontSize: CGFloat = 34
}

private extension Double {
    static let titleKern: Double = -0.02
    static let valueKern: Double = 0.54
}

struct InitialValueViewModel: Hashable {

    // MARK: - Enum
    enum Category {

        case initialDeposit
        case numberOfPeriods
        case profitability
        case investments

        var title: String {
            switch self {
            case .initialDeposit:
                return Localizations.Main.initialDeposit
            case .numberOfPeriods:
                return Localizations.Main.numberOfPeriods
            case .profitability:
                return Localizations.Main.profitability
            case .investments:
                return Localizations.Main.investments
            }
        }

        var placeholder: String {
            switch self {
            case .initialDeposit:
                return "1200" + .space + .currency
            case .numberOfPeriods:
                return "12 \(Localizations.Common.month)"
            case .profitability:
                return "0.8" + .space + .persent
            case .investments:
                return "10"  + .space + .currency
            }
        }

        var hint: String {
            switch self {
            case .initialDeposit:
                return Localizations.Main.Hint.initialDeposit
            case .numberOfPeriods:
                return Localizations.Main.Hint.numberOfPeriods
            case .profitability:
                return Localizations.Main.Hint.profitability
            case .investments:
                return Localizations.Main.Hint.investments
            }
        }

    }

    // MARK: - Properties
    let title: NSAttributedString
    let placeholder: NSAttributedString
    let hint: String

    // MARK: - Init
    init(with category: Category) {
        title = category.title.addAttributes(font: .regular(size: .titleFontSize),
                                             color: Colors.Text.comment.color,
                                             kern: .titleKern)

        placeholder = category.placeholder.addAttributes(font: .bold(size: .valueFontSize),
                                                         color: Colors.Text.comment.color,
                                                         kern: .valueKern)

        hint = category.hint
    }
}
