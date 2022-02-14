//
//  CharacterUseCase.swift
//  Rick-Morty-App
//
//  Created by SyedAbdulBasit on 05/02/2022.
//

import Foundation
import RxSwift

//typealias CharacterResponse = (Result<[Character], Error>) -> Void
protocol CharacterUseCaseProtocol {
    func fetchCharacters() -> Observable<[Character]>
}

final class CharacterUseCase: CharacterUseCaseProtocol {

    // MARK: - Private Property
    private let characterRepository: CharacterRepositoryProtocol
    // MARK: - Initializer
    /// Initialize the characterRepository
    /// - Parameter CharacterRepositoryProtocol
    init(characterRepository: CharacterRepositoryProtocol) {
        self.characterRepository = characterRepository
    }
    /// Load characters from character repo and returns the result

    func fetchCharacters() -> Observable<[Character]> {
        characterRepository.getCharacter()
    }
}
