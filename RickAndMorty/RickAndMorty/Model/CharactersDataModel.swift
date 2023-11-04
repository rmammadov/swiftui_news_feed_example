//
//  CharactersDataModel.swift
//  RickAndMorty
//
//  Created by Rahman Mammadov on 29.09.23.
//

import Foundation

struct CharactersDataModel: Codable{
    let info: Info?
    let results: [CharacterItem]?
}

struct Info: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}

struct CharacterItem: Codable, Identifiable, Equatable {
    let id: Int
    let name: String?
    let image: String?
}

