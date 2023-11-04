//
//  RickAndMortyApiCalls.swift
//  RickAndMorty
//
//  Created by Rahman Mammadov on 29.09.23.
//

import Foundation
import Combine

protocol RickAndMortyApiCallsProtocol {
    func getCharacters(url: String) -> AnyPublisher<NetworkService.Response<CharactersDataModel>, Error>
}

class RickAndMortyApiCalls {
    static let service = NetworkService()
    static private let CONFIG_PAGE_SIZE = 10
}

extension RickAndMortyApiCalls: RickAndMortyApiCallsProtocol {
    func getCharacters(url: String) -> AnyPublisher<NetworkService.Response<CharactersDataModel>, Error> {
        let url = URL(string: url)
        return RickAndMortyApiCalls.service.run(url!)
    }
}
