//
//  File.swift
//  
//
//  Created by Gus Adi on 15/09/23.
//

import Foundation

public protocol PokemonLocalDataSource {
    func addPokemon(id: UInt, name: String, root: String) throws
    func renamePokemon(oldName: String, newName: String) throws
    func loadAllPokemon() throws -> [Pokemon]
    func deleteSpesificPokemon(name: String) throws
    func deleteAllPokemon() throws
    func getSpesificPokemon(uid: UUID) throws -> Pokemon?
}
