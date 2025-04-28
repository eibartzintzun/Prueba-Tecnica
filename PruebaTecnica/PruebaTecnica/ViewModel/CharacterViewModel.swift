//
//  CharacterViewModel.swift
//  PruebaTecnica
//
//  Created by Eibar Tzintzun on 27/04/25.
//

import Foundation
import CoreData

@MainActor
class CharacterViewModel: ObservableObject {
    enum State {
        case noAction
        case loading
        case success(data: [CharacterEntity])
        case failed(error: String)
    }
    
    @Published private(set) var state: State = .noAction
    @Published var hasError: Bool = false
    
    private let apiManager: APIManager
    private let charactersContainer: NSPersistentContainer
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
        self.charactersContainer = NSPersistentContainer(name: Constants.characterContainer)
        self.charactersContainer.loadPersistentStores { [weak self] description, error in
            if let error = error {
                self?.throwError(error)
            }
        }
        
        let savedCharactersEntities = self.getAllCharacters()
        
        if savedCharactersEntities.isEmpty {
            Task {
                await self.getCharactersFromApi()
            }
        } else {
            self.state = .success(data: savedCharactersEntities)
        }
    }
    
    func getCharactersFromApi() async {
        self.state = .loading
        
        do {
            let characters = try await apiManager.fetchCharacters()
            self.addCharacters(characters)
        } catch {
            throwError(error)
        }
    }
    
    func getAllCharacters() -> [CharacterEntity] {
        let request = NSFetchRequest<CharacterEntity>(entityName: Constants.characterEntity)
        
        do {
            return try self.charactersContainer.viewContext.fetch(request)
        } catch let error {
            throwError(error)
            return []
        }
    }
    
    func addCharacters(_ characters: [Character]) {
        for character in characters {
            let newCharacter = CharacterEntity(context: self.charactersContainer.viewContext)
            newCharacter.id = Int64(character.id ?? 0)
            newCharacter.name = character.name
            newCharacter.imageUrl = character.imageUrl
            newCharacter.isFavorite = false
            self.saveData()
        }
    }
    
    func saveData() {
        do {
            try self.charactersContainer.viewContext.save()
            self.state = .success(data: self.getAllCharacters())
        } catch let error {
            throwError(error)
        }
    }
    
    func updateCharacter(entity: CharacterEntity) {
        entity.isFavorite = !entity.isFavorite
        self.saveData()
    }
    
    func getFavoritesCharacters() -> [CharacterEntity] {
        let request = NSFetchRequest<CharacterEntity>(entityName: Constants.characterEntity)
        request.predicate = NSPredicate(format: "isFavorite == true")
        
        do {
            return try self.charactersContainer.viewContext.fetch(request)
        } catch let error {
            throwError(error)
            return []
        }
    }
    
    func throwError(_ error: Error) {
        self.state = .failed(error: error.localizedDescription)
        self.hasError = true
    }
}
