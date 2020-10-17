//
//  UITableView+Registration.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit.UITableView

extension UITableView {

    /**
     Метод для регистрации
     - Parameter type: Тип ячейки
     - Returns: HeaderFooterView
     */
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    /**
     Метод для регистрации и переиспользования ячейки
     - Parameter type: Тип ячейки
     - Parameter indexPath: indexPath ячейки
     - Returns: Ячейку типа type
     */
    func dequeueCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: T.self))")
        }
        return cell
    }

    /**
     Метод для регистрации и переиспользования ячейки
     - Parameter type: Тип вьюшки
     - Returns: HeaderFooterView типа type
     */
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) -> T {
        let reuseIdentifier = String(describing: viewClass)
        if let cell = self.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? T {
            return cell
        } else {
            register(viewClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        }
        return dequeueHeaderFooterView(viewClass)
    }

}
