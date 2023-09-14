//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation
import Moya

public extension MoyaProvider {
    func request<T: Codable>(_ target: Target, model: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation({ continuation in
            self.request(target) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let response):
                    let errorCode = response.statusCode
                    let jsonDecoder = JSONDecoder()
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    jsonDecoder.dateDecodingStrategy = .formatted(formatter)
                    
                    if response.statusCode >= 200 && response.statusCode < 299 {
                        do {
                            let decodedData = try jsonDecoder.decode(model.self, from: response.data)

                            continuation.resume(returning: decodedData)
                        } catch (let error) {
                            print(error)
                            continuation.resume(throwing: error)
                        }
                    } else if response.statusCode >= 500 && response.statusCode <= 599 {
                        let errorLocalized = ErrorResponse(status: errorCode, message: LocalizableString.generalInternalServerError)
                        continuation.resume(throwing: errorLocalized)
                    } else {
                        do {
                            let decodedData = try jsonDecoder.decode(ErrorResponse.self, from: response.data)

                            continuation.resume(throwing: decodedData)
                        } catch (let error) {
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        })
    }
}
