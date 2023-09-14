//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation

public extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
}
