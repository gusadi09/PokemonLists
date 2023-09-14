//
//  PokemonListsViewModel.swift
//  PokemonLists
//
//  Created by Gus Adi on 13/09/23.
//

import Foundation
import PokemonDataSource
import PokemonExtensions

final class PokemonListsViewModel: ObservableObject {
    
    private let pokemonRepository: PokemonRepository
    
    @Published var phase: ResultPhase<[PKPokemon]> = .initial
    
    
    init(pokemonRepository: PokemonRepository = PokemonDefaultRepository()) {
        self.pokemonRepository = pokemonRepository
    }
    
    @MainActor
    func getPokemonList(on offset: UInt = 0) async {
        self.phase = .loading
        
        do {
            let result = try await pokemonRepository.provideGetPokemonList(on: offset)
            
            self.phase = .result(result.results ?? [])
        } catch {
            self.phase = .error(error)
        }
    }
    
    func firstItem() -> PKPokemon? {
        self.phase.resultValue?.first
    }
}
