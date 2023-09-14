//
//  PokemonRepositoryTests.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import XCTest
@testable import PokemonDataSource

final class PokemonRepositoryTests: XCTestCase {

    private let sut = PokemonStubRepository(isErrorRemote: false)
    private let errorSut = PokemonStubRepository(isErrorRemote: true)
    
    func test_getPokemonListsSuccess() async throws {
        let result = try await sut.provideGetPokemonList(on: 0)
        
        XCTAssertEqual(result.count.orZero(), 1)
    }
    
    func test_getPokemonListsError() async throws {
        do {
            _ = try await errorSut.provideGetPokemonList(on: 0)
            
            XCTFail("Not Expected Result")
        } catch(let error as ErrorResponse) {
            XCTAssertEqual(error.status, 404)
        } catch {
            XCTAssertThrowsError(error)
        }
    }
}
