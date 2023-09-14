//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation

public struct ErrorResponse: Codable, Error {
    public let status: Int?
    public let message: String?

    public init(status: Int?, message: String?) {
        self.status = status
        self.message = message
    }
}
