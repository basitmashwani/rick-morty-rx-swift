//
//  CharacterRepository.swift
//  Rick-Morty-App
//
//  Created by SyedAbdulBasit on 05/02/2022.
//

import Foundation
import RxSwift

protocol CharacterRepositoryProtocol {
    /// it will fetch characters.
    func getCharacter() -> Observable<[Character]>
}

final class CharacterRepository: CharacterRepositoryProtocol {
    // MARK: - Protocol Implementation
    /// Fetch characters using datastore from api.
    func getCharacter() -> Observable<[Character]> {
        RestService
        .shared
        .request(.get, path: .getCharacter, parameters: nil)
        .parse(CharactersDTO.self, errorType: FailureDTO.self)
        .observe(on: MainScheduler.instance)
        .map { $0.characters.map { $0.toDomain() } }
        }
}
