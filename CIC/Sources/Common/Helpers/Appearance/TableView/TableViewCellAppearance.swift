//
//  TableViewCellAppearance.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 12/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

final class TableViewCellAppearance {

    // MARK: - Init
    private init() {}

    // MARK: - Configure
    class func configure() {
        UITableViewCell.appearance().backgroundColor = .background
        UITableViewCell.appearance().selectionStyle = .none
    }

}
