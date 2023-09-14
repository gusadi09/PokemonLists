//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation

public protocol PokemonRemoteDataSource {
    func getPokemonList(offset: UInt) async throws -> PKPokemonList
}
