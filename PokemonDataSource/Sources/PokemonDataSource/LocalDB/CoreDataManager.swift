//
//  File.swift
//  
//
//  Created by Gus Adi on 13/09/23.
//

import CoreData
import Foundation

class CoreDataManager: NSPersistentContainer {
 
    init() {
        guard
            let objectModelURL = Bundle.module.url(forResource: "Model", withExtension: "momd"),
            let objectModel = NSManagedObjectModel(contentsOf: objectModelURL)
        else {
            fatalError("Failed to retrieve the object model")
        }
        super.init(name: "Model", managedObjectModel: objectModel)
        self.initialize()
    }
    
    private func initialize() {
        self.loadPersistentStores { description, error in
            if let err = error {
                fatalError("Failed to load CoreData: \(err)")
            }
            print("Core data loaded: \(description)")
        }
    }
    
    func loadPokemon() throws -> [Pokemon] {
        let fetchRequest = try self.viewContext.fetch(Pokemon.fetchRequest())
        return fetchRequest
    }
    
    func savePokemon(name: String) throws {
        let entity = Pokemon(context: self.viewContext)
        
        entity.name = name
        
        if self.viewContext.hasChanges {
            try self.viewContext.save()
        }
    }
    
    func deletePokemon(name: String) throws {
        let data = try loadPokemon()
        
        for pokemon in data where pokemon.name == name {
            self.viewContext.delete(pokemon)
        }
        
        if self.viewContext.hasChanges {
            try self.viewContext.save()
        }
    }
    
    func deleteAllPokemon() throws {
        let item = try loadPokemon()
        
        for item in item {
            self.viewContext.delete(item)
        }
        
        if self.viewContext.hasChanges {
            try self.viewContext.save()
        }
    }
}
