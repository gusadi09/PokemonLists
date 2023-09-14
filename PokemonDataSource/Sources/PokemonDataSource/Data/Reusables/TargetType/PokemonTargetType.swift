//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation
import Moya
import PokemonExtensions

protocol PokemonTargetType: TargetType {
    var parameters: [String: Any] {
        get
    }
}

extension PokemonTargetType {

    public var baseURL: URL {
        return "https://pokeapi.co/api/v2".toURL() ?? (NSURL() as URL)
    }

    var parameterEncoding: Moya.ParameterEncoding {
        JSONEncoding.default
    }

    var task: Task {
        return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }

    public var headers: [String: String]? {
        return [:]
    }
}
