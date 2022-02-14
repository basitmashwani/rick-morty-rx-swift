//
//  MockCharacterUseCase.swift
//  Rick-Morty-AppTests
//
//  Created by SyedAbdulBasit on 06/02/2022.
//

import Foundation
import RxSwift
import RxCocoa
@testable import Rick_Morty_App

final class MockCharacterUseCase: CharacterUseCaseProtocol {
    let resultLoadCharacters = PublishSubject<[Character]>() //BehaviorRelay<[Character]>(value: MockCharacterData.characterData)
    
    func fetchCharacters() -> Observable<[Character]> {
        resultLoadCharacters.asObservable()

    }
}
