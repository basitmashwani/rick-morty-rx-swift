//
//  MockCharacterRepository.swift
//  Rick-Morty-AppTests
//
//  Created by SyedAbdulBasit on 06/02/2022.
//

import Foundation
import RxSwift

@testable import Rick_Morty_App

final class MockCharacterRepository: CharacterRepositoryProtocol {

    var resultLoadCharacters = PublishSubject<[Character]>()
    func getCharacter() -> Observable<[Character]> {
        resultLoadCharacters
    }
}
