//
//  PokemonDetailViewModel.swift
//  PokemonLists
//
//  Created by Gus Adi on 13/09/23.
//

import Foundation
import PokemonDataSource
import PokemonExtensions

final class PokemonDetailViewModel: ObservableObject {
    private let pokemonRepository: PokemonRepository
    
    @Published var phase: ResultPhase<PKPokemonDetail> = .initial
    
    init(pokemonRepository: PokemonRepository = PokemonDefaultRepository()) {
        self.pokemonRepository = pokemonRepository
    }
    
    @MainActor
    func getPokemonDetail(for id: UInt) async {
        self.phase = .loading
        
        do {
            let result = try await pokemonRepository.provideGetPokemonDetail(for: id)
            
            self.phase = .result(result)
        } catch {
            self.phase = .error(error)
        }
    }
}
