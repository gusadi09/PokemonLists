//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation

public extension Encodable {
    func toData() -> Data {
        guard let data =  try? JSONEncoder().encode(self) else {
            return Data()
        }
        
        return data
    }
}
