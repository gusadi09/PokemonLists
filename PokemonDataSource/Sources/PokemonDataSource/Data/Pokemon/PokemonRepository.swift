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
    func provideCatchPokemon(with id: UInt, nickname: String, root: String) throws
    func provideRenamePokemon(from old: String, to new: String) throws
    func provideLoadMyPokemon() throws -> [Pokemon]
    func provideDeleteSpesificPokemon(at name: String) throws
    func provideDeleteAllPokemon() throws
    func provideGetSpesificPokemon(uid: UUID) throws -> Pokemon?
}
