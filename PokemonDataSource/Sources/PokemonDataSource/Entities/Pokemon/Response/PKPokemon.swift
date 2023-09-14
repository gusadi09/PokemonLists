//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation

public struct PKPokemonList: Codable {
    public let count: Int?
    public let next: String?
    public let previous: String?
    public let results: [PKPokemon]?
    
    public init(count: Int?, next: String?, previous: String?, results: [PKPokemon]?) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

public struct PKPokemon: Codable, Hashable, Equatable {
    public let name: String?
    
    public init(name: String?) {
        self.name = name
    }
}

public extension PKPokemon {
    static var sample: PKPokemon {
        PKPokemon(name: "Test Pokemon")
    }
    
    static var sampleData: Data {
        sample.toData()
    }
}

public extension PKPokemonList {
    static var sample: PKPokemonList {
        PKPokemonList(
            count: 1,
            next: "available",
            previous: nil,
            results: [
                PKPokemon.sample
            ]
        )
    }
    
    static var sampleData: Data {
        sample.toData()
    }
}
