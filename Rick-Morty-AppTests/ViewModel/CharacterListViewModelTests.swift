//
//  CharacterListViewModelTests.swift
//  Rick-Morty-AppTests
//
//  Created by SyedAbdulBasit on 06/02/2022.
//

import XCTest
import RxSwift
import RxTest
@testable import Rick_Morty_App

class CharacterListViewModelTest: XCTestCase {

    var viewModel: CharacterListViewModel!
    var useCaseMock: MockCharacterUseCase!
    let disposeBag = DisposeBag()


    func testViewDidLoad_whenCharactersAreSuccessfullyLoaded_onLoad_of_view() {
        // given

        let useCase = MockCharacterUseCase()
        self.viewModel = CharacterListViewModel(useCase: useCase, inputs: CharacterListViewModel.Input(viewDidAppearTrigger: .empty(), refreshTrigger: .empty(), filterQuery: .just("")))
            // when
        let expectation = expectation(description: "waiting for the subscribe")
        viewModel.items
            .subscribe(onNext: { items in
                expectation.fulfill()
                XCTAssertEqual(items.count, MockCharacterData.characterData.count)

            }).disposed(by: disposeBag)
        useCase.resultLoadCharacters.onNext(MockCharacterData.characterData)

        waitForExpectations(timeout: 2)

    }



    func testViewDidLoad_whenCharacterAreFailedToLoad_shouldHaveFailed() {
        // given
        let useCaseMock = MockCharacterUseCase()
        self.viewModel = CharacterListViewModel(useCase: useCaseMock, inputs: CharacterListViewModel.Input(viewDidAppearTrigger: .empty(), refreshTrigger: .empty(), filterQuery: .just("")))
        let expectation = expectation(description: "waiting for the subscribe")
        viewModel.errorMessage
            .subscribe(onNext: { error in
                // then
                expectation.fulfill()
                XCTAssertEqual(error.localizedDescription, "Ops Something went wrong. Please try later!")

            }).disposed(by: disposeBag)

        // when
        useCaseMock.resultLoadCharacters.onError(RickMortyError.apiError)
        waitForExpectations(timeout: 2)


    }

    func test_search_invalid_character() {
        // given

        let useCase = MockCharacterUseCase()
        self.viewModel = CharacterListViewModel(useCase: useCase, inputs: CharacterListViewModel.Input(viewDidAppearTrigger: .empty(), refreshTrigger: .empty(), filterQuery: .just("Ricker mortel")))
            // when
        let expectation = expectation(description: "waiting for the subscribe")
        viewModel.items
            .subscribe(onNext: { items in
                expectation.fulfill()
                XCTAssertEqual(items.count, 0)

            }).disposed(by: disposeBag)
        useCase.resultLoadCharacters.onNext(MockCharacterData.characterData)

        waitForExpectations(timeout: 2)

    }

    func test_search_valid_character() {
        // given

        let useCase = MockCharacterUseCase()
        self.viewModel = CharacterListViewModel(useCase: useCase, inputs: CharacterListViewModel.Input(viewDidAppearTrigger: .empty(), refreshTrigger: .empty(), filterQuery: .just("Morty")))
            // when
        let expectation = expectation(description: "waiting for the subscribe")
        viewModel.items
            .subscribe(onNext: { items in
                expectation.fulfill()
                XCTAssertEqual(items.count, 1)

            }).disposed(by: disposeBag)
        useCase.resultLoadCharacters.onNext(MockCharacterData.characterData)

        waitForExpectations(timeout: 2)

    }

}
