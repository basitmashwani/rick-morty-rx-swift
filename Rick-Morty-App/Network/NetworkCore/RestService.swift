//
//  RestService.swift
//  Rick-Morty-App
//
//  Created by SyedAbdulBasit on 05/02/2022.
//
import Foundation
import RxSwift

final class RestService: HTTPService {
    static let shared = RestService()
    private var session: URLSession
    var baseURL: URL {
        URL(string: API.characterListEndPoint)!
    }
    private init() {
         session = URLSession.shared
    }
    func request(_ method: HTTPMethod, path: RickMortyApi, parameters: Parameters?,
                 queryItems: [URLQueryItem]? = nil) -> Observable<Data> {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path.path))
        if let queryParams = queryItems {
             let url = baseURL.appendingPathComponent(path.path).addQueryParms(queryParams)
                urlRequest = URLRequest(url: url)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return handleRequest(request: urlRequest)
    }

   private func handleRequest(request: URLRequest) -> Observable<Data> {
        self.session.rx.data(request: request)
    }

}
