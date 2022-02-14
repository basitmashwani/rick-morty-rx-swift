//
//  CharacterUseCaseTests.swift
//  Rick-Morty-AppTests
//
//  Created by SyedAbdulBasit on 06/02/2022.
//

import XCTest
import RxSwift
import RxCocoa
@testable import Rick_Morty_App

class CharacterUseCaseTests: XCTestCase {
    private let disposedBag = DisposeBag()
    func testLoadCharacters_whenSuccessfullyFetchesCharacter_shouldHaveCharacters() {
        // given
        let mockCharacterRepository = MockCharacterRepository()
        let useCase = CharacterUseCase(characterRepository: mockCharacterRepository)
        // when
        let expectation = expectation(description: "waiting for the subscribe")
        useCase.fetchCharacters()
            .subscribe(onNext: { characters in
                expectation.fulfill()
                XCTAssertEqual(characters.count, MockCharacterData.characterData.count)
            }).disposed(by: disposedBag)
        mockCharacterRepository.resultLoadCharacters.onNext(MockCharacterData.characterData)
        waitForExpectations(timeout: 2.0)
    }
    func testLoadCharacters_whenFailedFetchingCharacters_serverReturnsError() {
        // given
        let mockCharacterRepository = MockCharacterRepository()
        // when
        let expectation = expectation(description: "waiting for the subscribe")
        let useCase = CharacterUseCase(characterRepository: mockCharacterRepository)
        useCase.fetchCharacters()
            .asObservable()
            .subscribe { _ in
            } onError: { error in
                expectation.fulfill()
                XCTAssertEqual(error.localizedDescription, RickMortyError.apiError.localizedDescription)
            }.disposed(by: disposedBag)

        mockCharacterRepository.resultLoadCharacters.onError(RickMortyError.apiError)
        waitForExpectations(timeout: 2.0)

    }
}
