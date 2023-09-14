//
//  File.swift
//  
//
//  Created by Gus Adi on 15/09/23.
//

import CoreData
import Foundation

public final class PokemonDefaultLocalDataSource: PokemonLocalDataSource {
    
    private let coreData: PokemonCoreDataManager
    
    public init(coreData: PokemonCoreDataManager = PokemonCoreDataManager()) {
        self.coreData = coreData
    }
    
    public func addPokemon(id: UInt, name: String, root: String) throws {
        try coreData.savePokemon(id: id, name: name, root: root)
    }
    
    public func renamePokemon(oldName: String, newName: String) throws {
        try coreData.editPokemon(name: oldName, newValue: newName)
    }
    
    public func loadAllPokemon() throws -> [Pokemon] {
        try coreData.loadPokemon()
    }
}
