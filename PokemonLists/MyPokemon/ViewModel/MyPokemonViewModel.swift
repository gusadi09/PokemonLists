//
//  MyPokemonViewModel.swift
//  PokemonLists
//
//  Created by Gus Adi on 13/09/23.
//

import Foundation
import PokemonDataSource

enum ReleaseStatus {
    case success
    case fail
}

final class MyPokemonViewModel: ObservableObject {
    
    private let pokemonRepository: PokemonRepository
    
    @Published var savedList: [Pokemon] = []
    @Published var error: String? = nil
    @Published var isError = false
    
    @Published var uid: UUID? = nil
    @Published var id: UInt? = 1
    
    @Published var nickname: String? = nil
    
    @Published var releaseStat: ReleaseStatus? = nil
    @Published var isShowAlert = false
    
    init(pokemonRepository: PokemonRepository = PokemonDefaultRepository()) {
        self.pokemonRepository = pokemonRepository
    }
    
    func isPrimeNumber(_ number: Int) -> Bool {
        if number <= 1 {
            return false
        }
        if number <= 3 {
            return true
        }
        if number % 2 == 0 || number % 3 == 0 {
            return false
        }
        
        var i = 5
        while i * i <= number {
            if number % i == 0 || number % (i + 2) == 0 {
                return false
            }
            i += 6
        }
        
        return true
    }
    
    @MainActor
    func releasePokemon(name: String, completion: () -> Void) {
        releaseStat = nil
        isShowAlert = false
        
        let number = Int.random(in: 0...999)
        
        if isPrimeNumber(number) {
            do {
                try pokemonRepository.provideDeleteSpesificPokemon(at: name)
                
                isShowAlert = true
                releaseStat = .success
                completion()
            } catch {
                isShowAlert = true
                releaseStat = .fail
            }
        } else {
            isShowAlert = true
            releaseStat = .fail
        }
    }
    
    @MainActor
    func getAllPokemon() {
        
        self.isError = false
        self.error = nil
        
        do {
            let data = try pokemonRepository.provideLoadMyPokemon()
            
            self.savedList = data
            self.uid = self.savedList.first?.uid
            self.nickname = self.savedList.first?.name
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
