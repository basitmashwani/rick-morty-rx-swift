//
//  Optional+Rx.swift
//  Rick-Morty-App
//
//  Created by SyedAbdulBasit on 07/02/2022.
//

import RxSwift
extension ObservableType {
    public func unwrap<T>() -> Observable<T> where Element == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}
