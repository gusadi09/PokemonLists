//
//  File.swift
//  
//
//  Created by Gus Adi on 13/09/23.
//

import CoreData
import Foundation

public class PokemonCoreDataManager {
 
    public static let shared = PokemonCoreDataManager()
    
    let container: NSPersistentContainer
    
    public init() {
        guard
            let objectModelURL = Bundle.module.url(forResource: "Model", withExtension: "momd"),
            let objectModel = NSManagedObjectModel(contentsOf: objectModelURL)
        else {
            fatalError("Failed to retrieve the object model")
        }
        self.container = NSPersistentContainer(name: "Model", managedObjectModel: objectModel)
        
        self.container.loadPersistentStores { description, error in
            if let err = error {
                fatalError("Failed to load CoreData: \(err)")
            }
            print("Core data loaded: \(description)")
        }
        
        self.container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func loadPokemon() throws -> [Pokemon] {
        let fetchRequest = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        return try self.container.viewContext.fetch(fetchRequest)
    }
    
    func savePokemon(id: UInt, name: String, root: String) throws {
        let entity = Pokemon(context: self.container.viewContext)
        
        entity.uid = UUID()
        entity.id = Int64(id)
        entity.name = name
        entity.rootParent = root
        entity.renameAttempt = 0
        
        if self.container.viewContext.hasChanges {
            self.container.viewContext.insert(entity)
            try self.container.viewContext.save()
            self.container.viewContext.reset()
        }
    }
    
    func editPokemon(name: String, newValue: String) throws {
        let fetchRequest = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        
        guard let data = try self.container.viewContext.fetch(fetchRequest).first else { return }
        
        data.name = "\(newValue)-\(fibonacciSeries(num: data.renameAttempt))"
        data.renameAttempt += 1
        if self.container.viewContext.hasChanges {
            try self.container.viewContext.save()
            self.container.viewContext.reset()
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
        let fetchRequest = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        
        guard let data = try self.container.viewContext.fetch(fetchRequest).first else { return }
        
        self.container.viewContext.delete(data)
        
        if self.container.viewContext.hasChanges {
            try self.container.viewContext.save()
            self.container.viewContext.reset()
        }
    }
    
    func deleteAllPokemon() throws {
        let item = try loadPokemon()
        
        for item in item {
            self.container.viewContext.delete(item)
        }
        
        if self.container.viewContext.hasChanges {
            try self.container.viewContext.save()
            self.container.viewContext.reset()
        }
    }
}
