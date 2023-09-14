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
    
    @Published var currentOffset: UInt = 0
    
    @Published var isNextAvailable = false
    
    @Published var isPrevAvailable = false
    
    init(pokemonRepository: PokemonRepository = PokemonDefaultRepository()) {
        self.pokemonRepository = pokemonRepository
    }
    
    @MainActor
    func decreaseOffset() {
        Task {
            self.currentOffset -= 1
            await self.getPokemonList()
        }
    }
    
    @MainActor
    func increaseOffset() {
        Task {
            self.currentOffset += 1
            await self.getPokemonList()
        }
    }
    
    @MainActor
    func getPokemonList() async {
        
        self.phase = .loading
        
        do {
            let result = try await pokemonRepository.provideGetPokemonList(on: self.currentOffset*20)
            
            self.phase = .result(result.results ?? [])
            self.isNextAvailable = result.next != nil
            self.isPrevAvailable = result.previous != nil
        } catch {
            self.phase = .error(error)
        }
    }
    
    func firstItem() -> PKPokemon? {
        self.phase.resultValue?.first
    }
}
