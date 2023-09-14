//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation

public extension Optional where Wrapped == Bool {
    func orFalse() -> Bool {
        return self ?? false
    }
}
