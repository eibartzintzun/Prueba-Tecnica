//
//  CharacterResult.swift
//  PruebaTecnica
//
//  Created by Eibar Tzintzun on 27/04/25.
//

import Foundation

struct CharacterResult: Codable {
    let data: [Character]?
}

struct Character: Codable {
    let id: Int?
    let name: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case imageUrl = "imageUrl"
    }
}
