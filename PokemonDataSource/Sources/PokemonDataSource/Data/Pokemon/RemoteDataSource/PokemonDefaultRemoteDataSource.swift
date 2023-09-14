//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation
import Moya

final public class PokemonDefaultRemoteDataSource: PokemonRemoteDataSource {
    
    private let provider: MoyaProvider<PokemonTargetType>
    
    public init(provider: MoyaProvider<PokemonTargetType> = .defaultProvider()) {
        self.provider = provider
    }
    
    public func getPokemonList(offset: UInt) async throws -> PKPokemonList {
        try await self.provider.request(.getPokemonList(offset), model: PKPokemonList.self)
    }
}
