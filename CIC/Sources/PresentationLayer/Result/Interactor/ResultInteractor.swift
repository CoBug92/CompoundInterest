//
//  ResultInteractor.swift
//  CIC
//
//  Created by Богдан Костюченко on 31/01/2020.
//  Copyright © 2020 Bogdan Kostyuchenko. All rights reserved.
//

final class ResultInteractor {

    // MARK: - Protocols properties
    weak var output: ResultInteractorOutput?

}

// MARK: - ResultInteractorInput
extension ResultInteractor: ResultInteractorInput {}
