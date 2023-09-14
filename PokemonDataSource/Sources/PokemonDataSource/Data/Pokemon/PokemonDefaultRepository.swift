//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation

public final class PokemonDefaultRepository: PokemonRepository {
    
    private let remote: PokemonRemoteDataSource
    private let local: PokemonLocalDataSource
    
    public init(
        remote: PokemonRemoteDataSource = PokemonDefaultRemoteDataSource(),
        local: PokemonLocalDataSource = PokemonDefaultLocalDataSource()
    ) {
        self.remote = remote
        self.local = local
    }
    
    public func provideGetPokemonList(on offset: UInt) async throws -> PKPokemonList {
        try await self.remote.getPokemonList(offset: offset)
    }
    
    public func provideGetPokemonDetail(for id: UInt) async throws -> PKPokemonDetail {
        try await self.remote.getPokemonDetail(id: id)
    }
    
    public func provideLoadMyPokemon() throws -> [Pokemon] {
        try self.local.loadAllPokemon()
    }
    
    public func provideCatchPokemon(with id: UInt, nickname: String, root: String) throws {
        try self.local.addPokemon(id: id, name: nickname, root: root)
    }
    
    public func provideRenamePokemon(from old: String, to new: String) throws {
        try self.local.renamePokemon(oldName: old, newName: new)
    }
    
    public func provideDeleteSpesificPokemon(at name: String) throws {
        try self.local.deleteSpesificPokemon(name: name)
    }
    
    public func provideDeleteAllPokemon() throws {
        try self.local.deleteAllPokemon()
    }
}
