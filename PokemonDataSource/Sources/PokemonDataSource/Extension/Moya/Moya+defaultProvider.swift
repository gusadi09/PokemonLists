//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation
import Moya

public extension MoyaProvider {
    static func defaultProvider() -> MoyaProvider {
        return MoyaProvider(plugins: [NetworkLoggerPlugin()])
    }
}
