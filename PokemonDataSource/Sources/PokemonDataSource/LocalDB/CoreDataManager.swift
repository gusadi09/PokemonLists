//
//  File.swift
//  
//
//  Created by Gus Adi on 13/09/23.
//

import CoreData
import Foundation

public class PokemonCoreDataManager: NSPersistentContainer {
 
    public init() {
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
    
    func savePokemon(id: UInt, name: String, root: String) throws {
        let entity = Pokemon(context: self.viewContext)
        
        entity.uid = UUID()
        entity.id = Int64(id)
        entity.name = name
        entity.rootParent = root
        entity.renameAttempt = 0
        
        if self.viewContext.hasChanges {
            try self.viewContext.save()
        }
    }
    
    func editPokemon(name: String, newValue: String) throws {
        let fetchRequest = Pokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        
        guard let data = try self.viewContext.fetch(fetchRequest).first else { return }
        
        data.name = "\(newValue)-\(fibonacciSeries(num: data.renameAttempt))"
        data.renameAttempt += 1
        if self.viewContext.hasChanges {
            try self.viewContext.save()
        }
    }
    
    func fibonacciSeries(num: Int64) -> Int64 {
       if (num == 0){
          return 0
       }
       else if (num == 1){
          return 1
       }
        
       return fibonacciSeries(num: num - 1) + fibonacciSeries(num: num -  2)
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
