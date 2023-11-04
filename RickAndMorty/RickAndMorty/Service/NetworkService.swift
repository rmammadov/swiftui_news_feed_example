//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Rahman Mammadov on 29.09.23.
//

import Combine
import Foundation

   
struct NetworkService {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }

    func run<T: Decodable>(_ url: URL, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return SessionBuilder.build()
            .dataTaskPublisher(for: URLRequest(url: url))
            .tryMap { result -> Response<T> in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
