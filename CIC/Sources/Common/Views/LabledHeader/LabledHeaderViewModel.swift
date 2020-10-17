//
//  LabledHeaderViewModel.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let fontSize: CGFloat = 20
}

private extension Double {
    static let kern: Double = 0.32
}

struct LabledHeaderViewModel: Hashable {

    // MARK: - Properties
    let headerTitle: NSAttributedString

    // MARK: - Init
    init(from string: String) {
        headerTitle = string.addAttributes(font: .bold(size: .fontSize), color: Colors.Text.primary.color, kern: .kern)
    }

}
