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
    public let url: String?
    
    public init(name: String?, url: String?) {
        self.name = name
        self.url = url
    }
}

public extension PKPokemon {
    static var sample: PKPokemon {
        PKPokemon(name: "Test Pokemon", url: "1")
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

public struct PKMove: Codable {
    public let name: String?
    
    public init(name: String?) {
        self.name = name
    }
}

public extension PKMove {
    static var sample: PKMove {
        PKMove(name: "Test Move")
    }
    
    static var sampleData: Data {
        sample.toData()
    }
}

public struct PKSprite: Codable {
    public let other: PKOtherSprite?
    
    public init(other: PKOtherSprite?) {
        self.other = other
    }
}

public extension PKSprite {
    static var sample: PKSprite {
        PKSprite(other: PKOtherSprite.sample)
    }
    
    static var sampleData: Data {
        sample.toData()
    }
}

public struct PKOtherSprite: Codable {
    public let dreamWorld: PKDreamWorldSprite?
    
    public init(dreamWorld: PKDreamWorldSprite?) {
        self.dreamWorld = dreamWorld
    }
    
    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
    }
}

public extension PKOtherSprite {
    static var sample: PKOtherSprite {
        PKOtherSprite(dreamWorld: PKDreamWorldSprite.sample)
    }
    
    static var sampleData: Data {
        sample.toData()
    }
}

public struct PKDreamWorldSprite: Codable {
    public let frontDefault: String?
    
    public init(frontDefault: String?) {
        self.frontDefault = frontDefault
    }
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

public extension PKDreamWorldSprite {
    static var sample: PKDreamWorldSprite {
        PKDreamWorldSprite(frontDefault: "sprite")
    }
    
    static var sampleData: Data {
        sample.toData()
    }
}

public struct PKType: Codable {
    public let slot: Int?
    public let type: PKTypeData?
    
    public init(slot: Int?, type: PKTypeData?) {
        self.slot = slot
        self.type = type
    }
}

public extension PKType {
    static var sample: PKType {
        PKType(slot: 1, type: PKTypeData.sample)
    }
    
    static var sampleData: Data {
        sample.toData()
    }
}

public struct PKTypeData: Codable {
    public let name: String?
    public let url: String?
    
    public init(name: String?, url: String?) {
        self.name = name
        self.url = url
    }
}

public extension PKTypeData {
    static var sample: PKTypeData {
        PKTypeData(name: "test type", url: "type")
    }
    
    static var sampleData: Data {
        sample.toData()
    }
}

public struct PKPokemonDetail: Codable {
    public let name: String?
    public let sprites: [PKSprite]?
    public let types: [PKType]?
    public let moves: [PKMove]?
    public let weight: UInt?
    public let height: UInt?
    
    public init(
        name: String?,
        sprites: [PKSprite]?,
        types: [PKType]?,
        moves: [PKMove]?,
        weight: UInt?,
        height: UInt?
    ) {
        self.name = name
        self.sprites = sprites
        self.types = types
        self.moves = moves
        self.weight = weight
        self.height = height
    }
}

public extension PKPokemonDetail {
    static var sample: PKPokemonDetail {
        PKPokemonDetail(
            name: "test",
            sprites: [PKSprite.sample],
            types: [PKType.sample],
            moves: [PKMove.sample],
            weight: 10,
            height: 10
        )
    }
    
    static var sampleData: Data {
        sample.toData()
    }
}
