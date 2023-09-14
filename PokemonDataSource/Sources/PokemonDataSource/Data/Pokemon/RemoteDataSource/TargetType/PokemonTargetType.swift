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
}

extension PokemonTargetType: PokemonAppTargetType {
    var parameters: [String : Any] {
        switch self {
        case .getPokemonList(let offset):
            return [
                "limit": 20,
                "offset": offset
            ]
        }
    }

    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .getPokemonList:
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
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .getPokemonList:
            return PKPokemonList.sampleData
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getPokemonList:
            return .get
        }
    }
}
