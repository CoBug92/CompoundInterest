//
//  Publisher+mapToVoid.swift
//  CIC
//
//  Created by Костюченко Богдан Сергеевич on 16.10.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Combine

extension Publisher where Self.Output: Any, Self.Failure == Never {

    func mapToVoid() -> AnyPublisher<Void, Never> {
        return map({ _ in })
            .eraseToAnyPublisher()
    }

}
