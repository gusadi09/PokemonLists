//
//  ResultPhase.swift
//  PokemonLists
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation
import PokemonDataSource
import PokemonExtensions

enum ResultPhase<T: Codable> {
    case initial
    case loading
    case error(Error)
    case result(T)
}

extension ResultPhase: Equatable {
    static func == (lhs: ResultPhase<T>, rhs: ResultPhase<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loading, .error):
            return false
        case (.loading, .initial):
            return false
        case (.loading, .result):
            return false
        case (.error, .error):
            return true
        case (.error, .loading):
            return false
        case (.error, .initial):
            return false
        case (.error, .result):
            return false
        case (.initial, .initial):
            return true
        case (.initial, .error):
            return false
        case (.initial, .loading):
            return false
        case (.initial, .result):
            return false
        case (.result, .result):
            return true
        case (.result, .initial):
            return false
        case (.result, .loading):
            return false
        case (.result, .error):
            return false
        }
    }
    
    var errorValue: String? {
        switch self {
        case .initial:
            return nil
        case .loading:
            return nil
        case .error(let errorResponse):
            guard let error = errorResponse as? ErrorResponse else { return errorResponse.localizedDescription }
            return error.message
        case .result:
            return nil
        }
    }
    
    var resultValue: T? {
        switch self {
        case .initial:
            return nil
        case .loading:
            return nil
        case .error:
            return nil
        case .result(let t):
            return t
        }
    }
}
