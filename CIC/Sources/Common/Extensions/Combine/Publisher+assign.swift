//
//  Publisher+assign.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 17.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine

extension Publisher where Self.Failure == Never {

    func assignUnretained<Root>(
        to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
        on object: Root
    ) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] in object?[keyPath: keyPath] = $0 }
    }

    func assignUnretained<Root>(
        to keyPath: ReferenceWritableKeyPath<Root, Self.Output?>,
        on object: Root
    ) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] in object?[keyPath: keyPath] = $0 }
    }

}
