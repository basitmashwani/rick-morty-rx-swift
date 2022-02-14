//
//  Observable+Data.swift
//  Rick-Morty-App
//
//  Created by SyedAbdulBasit on 07/02/2022.
//

import Foundation
import RxSwift
import RxCocoa
extension ObservableType where Element == Data {

    func parse<T: Decodable, Err: Decodable & Error>(_ successType: T.Type = T.self, errorType: Err.Type = Err.self) -> Observable<T> {
        let decoder = JSONDecoder()

        return map { data in
            return try decoder.decode(successType, from: data)
            }
        .catch { originalError in
                guard case RxCocoaURLError.httpRequestFailed(_, .some(let data)) = originalError else {
                    return Observable.error(originalError)
                }
                do {
                    let serviceError = try decoder.decode(errorType, from: data)
                    print(serviceError.localizedDescription)
                    return Observable.error(serviceError)
                } catch {
                    print(error.localizedDescription)
                    return Observable.error(originalError)
                }
        }
    }

    func parseError<Err: Decodable & Error>(errorType: Err.Type = Err.self) -> Observable<Void> {

        return map { _ in () }
        .catch {originalError in
                guard case RxCocoaURLError.httpRequestFailed(_, .some(let data)) = originalError else {
                    return Observable.error(originalError)
                }
                do {
                    let decoder = JSONDecoder()
                    let serviceError = try decoder.decode(errorType, from: data)
                    return Observable.error(serviceError)
                } catch {
                    return Observable.error(originalError)
                }
        }

    }
}
