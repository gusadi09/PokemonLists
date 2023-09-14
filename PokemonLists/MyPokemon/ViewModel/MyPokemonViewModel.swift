//
//  MyPokemonViewModel.swift
//  PokemonLists
//
//  Created by Gus Adi on 13/09/23.
//

import Foundation
import PokemonDataSource

final class MyPokemonViewModel: ObservableObject {
    
    private let pokemonRepository: PokemonRepository
    
    @Published var savedList: [Pokemon] = []
    @Published var error: String? = nil
    @Published var isError = false
    
    @Published var uid: UUID? = UUID()
    @Published var id: UInt? = 1
    
    @Published var nickname = ""
    
    init(pokemonRepository: PokemonRepository = PokemonDefaultRepository()) {
        self.pokemonRepository = pokemonRepository
    }
    
    @MainActor
    func getAllPokemon() {
        
        self.isError = false
        self.error = nil
        self.savedList = []
        
        do {
            let data = try pokemonRepository.provideLoadMyPokemon()
            
            self.savedList = data
            self.uid = self.savedList.first?.uid
            self.nickname = (self.savedList.first?.name).orEmpty()
            self.id = UInt(self.savedList.first?.id ?? 0)
        } catch {
            self.isError = true
            self.error = error.localizedDescription
        }
    }
    
    func firstItem() -> Pokemon? {
        self.savedList.first
    }
}
