//
//  TableViewAppearance.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 12/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

final class TableViewAppearance {

    // MARK: - Init
    private init() {}

    // MARK: - Configure
    class func configure() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .background
    }

}
