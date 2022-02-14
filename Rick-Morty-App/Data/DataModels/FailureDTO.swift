//
//  FailureDTO.swift
//  Rick-Morty-App
//
//  Created by SyedAbdulBasit on 07/02/2022.
//

import Foundation

struct FailureDTO: Decodable & Error {
    let result: Bool
    let resultDetails: String?
    let uri: String
    let timestamp: String
    let errors: [ErrorModel]
}

struct ErrorModel: Decodable {
    let errorCode: Int
    let errorDescription: String?
    let errorResolve: String

    private enum CodingKeys: String, CodingKey {
        case errorCode = "code"
        case errorDescription = "description"
        case errorResolve = "resolve"
    }
}
