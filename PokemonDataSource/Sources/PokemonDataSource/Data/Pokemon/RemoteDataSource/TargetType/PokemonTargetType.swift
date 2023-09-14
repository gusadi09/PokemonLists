//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation

import Moya

public enum PokemonTargetType {
    case getPokemonList(UInt)
    case getDetailPokemon(UInt)
}

extension PokemonTargetType: PokemonAppTargetType {
    var parameters: [String : Any] {
        switch self {
        case .getPokemonList(let offset):
            return [
                "limit": 20,
                "offset": offset
            ]
        case .getDetailPokemon:
            return [:]
        }
    }

    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .getPokemonList:
            return URLEncoding.default
        case .getDetailPokemon:
            return URLEncoding.default
        }
    }

    public var task: Task {
        return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }

    public var path: String {
        switch self {
        case .getPokemonList:
            return "/pokemon"
        case .getDetailPokemon(let id):
            return "/pokemon/\(id)"
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .getPokemonList:
            return PKPokemonList.sampleData
        case .getDetailPokemon:
            return PKPokemonDetail.sampleData
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getPokemonList:
            return .get
        case .getDetailPokemon:
            return .get
        }
    }
}
