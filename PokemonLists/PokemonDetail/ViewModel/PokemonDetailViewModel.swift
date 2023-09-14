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
    
    @Published var showMoreMoves = false
    
    @Published var isRanAway = false
    @Published var showSavePrompt = false
    @Published var nickname = ""
    
    @Published var isSuccessToSave = false
    
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
    
    @MainActor
    func showMoreMoveToggle() {
        self.showMoreMoves.toggle()
    }
    
    func showText() -> String {
        showMoreMoves ? LocalizableText.detailShowLess : LocalizableText.detailShowMore
    }
    
    func picture() -> URL? {
        (
            self.phase.resultValue?.sprites?.other?.officialArtwork?.frontDefault
        ).orEmpty().toURL()
    }
    
    func movesArray() -> [PKMove] {
        guard let array = phase.resultValue?.moves else { return [] }
        
        return showMoreMoves ? array : Array(array.prefix(9))
    }
    
    func tryToCatch() {
        isRanAway = false
        showSavePrompt = false
        
        let randomValue = arc4random_uniform(2)
        
        if randomValue == 0 {
            isRanAway = false
            showSavePrompt = true
            print("Caught")
        } else {
            isRanAway = true
            showSavePrompt = false
            print("Fail")
        }
    }
    
    @MainActor
    func catchPokemon(id: UInt, name: String, root: String) {
        isRanAway = false
        
        do {
            try pokemonRepository.provideCatchPokemon(with: id, nickname: name, root: root)
            
            isSuccessToSave = true
        } catch {
            isRanAway = true
        }
    }
}
