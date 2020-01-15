//
//  UITableView+Registration.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 12/01/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit.UITableView

extension UITableView {

    /**
    Метод для регистрации ячейки
     - Parameter indexPath: IndexPath
     - Parameter cellClass: Класс ячейки
     - Returns: Ячейка
     - Authors: Bogdan Kostyuchenko
    */
    func cell<T: UITableViewCell>(at indexPath: IndexPath, for cellClass: T.Type) -> T {
        let reuseIdentifier = String(describing: cellClass)
        if let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T {
            return cell
        } else {
            register(cellClass, forCellReuseIdentifier: reuseIdentifier)
        }
        return cell(at: indexPath, for: cellClass)
    }

}
