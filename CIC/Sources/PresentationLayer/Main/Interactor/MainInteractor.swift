//
//  MainInteractor.swift
//  CIC
//
//  Created by Bogdan Kostyuchenko on 14/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

final class MainInteractor {

    // MARK: - Protocols properties
    weak var output: MainInteractorOutput?

}

// MARK: - MainInteractorInput
extension MainInteractor: MainInteractorInput {}
