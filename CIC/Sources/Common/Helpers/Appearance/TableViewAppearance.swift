//
//  TableViewAppearance.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

enum TableViewAppearance {

    static func configure() {
        let appearance = UITableView.appearance()
        appearance.separatorStyle = .none
        appearance.backgroundColor = Colors.Background.primary.color
    }

}
