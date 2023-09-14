//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation

public final class PokemonDefaultRepository: PokemonRepository {
    
    private let remote: PokemonRemoteDataSource
    
    public init(
        remote: PokemonRemoteDataSource = PokemonDefaultRemoteDataSource()
    ) {
        self.remote = remote
    }
    
    public func provideGetPokemonList(on offset: UInt) async throws -> PKPokemonList {
        try await self.remote.getPokemonList(offset: offset)
    }
    
    public func provideGetPokemonDetail(for id: UInt) async throws -> PKPokemonDetail {
        try await self.remote.getPokemonDetail(id: id)
    }
}
