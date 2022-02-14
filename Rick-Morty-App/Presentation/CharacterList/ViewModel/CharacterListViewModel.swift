//
//  CharacterListViewModel.swift
//  Rick-Morty-App
//
//  Created by SyedAbdulBasit on 05/02/2022.
//

import RxSwift
import RxCocoa
import Foundation
enum CharacterListViewState: Equatable {
    case loading
    case loaded
    case failed(String?)
}

struct CharacterListViewModel {
    // MARK: - Input
    struct Input {
        let viewDidAppearTrigger: Observable<Void>
        let refreshTrigger: Observable<Void>
        let filterQuery: Observable<String>
    }
    // MARK: - Output
        let items: Observable<[CharacterCellItemViewModel]>
         let errorMessage: Observable<RickMortyError>
    private let disposedBag = DisposeBag()

    // MARK: - Variables
    private let useCase: CharacterUseCaseProtocol
    private var characterItems: Observable<[CharacterCellItemViewModel]>
    // MARK: - Initializer
    init(useCase: CharacterUseCaseProtocol, inputs: Input) {
        self.useCase = useCase

        let response = Observable.merge(inputs.viewDidAppearTrigger.skip(1), inputs.refreshTrigger.startWith(()))
            .flatMapLatest {
                useCase.fetchCharacters()
                    .materialize()
            }.share()

        characterItems = response
            .map { $0.element }
            .filter { $0 != nil}
            .unwrap()
            .map { item in
                item.map { CharacterCellItemViewModel(item: $0)}
            }

        items = Observable.combineLatest(characterItems, inputs.filterQuery)
            .asObservable()
            .map{(item, filterQuery) in
                filterQuery.isEmpty ? item : item.filter { $0.name.contains(filterQuery)}
        }

         let apiError = response
             .map { $0.error }
             .filter { $0 != nil}
             .unwrap()
             .map { _ in RickMortyError.apiError}

        let emptyError = response
             .map { $0.element }
             .filter { $0 != nil}
             .unwrap()
             .filter { $0.isEmpty}
             .map {_ in RickMortyError.characterNotFound}

        errorMessage = Observable.merge(apiError, emptyError)
    }
}
