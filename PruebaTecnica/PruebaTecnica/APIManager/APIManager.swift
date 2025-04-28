//
//  APIManager.swift
//  PruebaTecnica
//
//  Created by Eibar Tzintzun on 27/04/25.
//

import Foundation

struct APIManager {
    enum APIManagerError: Error {
        case error
    }
    
    func fetchCharacters() async throws -> [Character] {
        let url = URL(string: Constants.apiUrl)!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIManagerError.error
        }
        
        let decodedData = try JSONDecoder().decode(CharacterResult.self, from: data)
        
        guard let data = decodedData.data else {
            throw APIManagerError.error
        }
        
        return data
    }
}
