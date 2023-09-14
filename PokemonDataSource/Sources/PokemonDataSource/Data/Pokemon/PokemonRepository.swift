//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation

public protocol PokemonRepository {
    func provideGetPokemonList(on offset: UInt) async throws -> PKPokemonList
    func provideGetPokemonDetail(for id: UInt) async throws -> PKPokemonDetail
}
