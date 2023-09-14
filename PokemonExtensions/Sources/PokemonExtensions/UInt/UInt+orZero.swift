//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation

public extension Optional where Wrapped == UInt {
    func orZero() -> UInt {
        return self ?? 0
    }
}
