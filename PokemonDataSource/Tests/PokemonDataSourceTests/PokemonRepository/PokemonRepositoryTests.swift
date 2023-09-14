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
    
    func test_getPokemonDetailSuccess() async throws {
        let result = try await sut.provideGetPokemonDetail(for: 1)
        
        XCTAssertEqual(result.name, "test")
    }
    
    func test_getPokemonDetailError() async throws {
        do {
            _ = try await errorSut.provideGetPokemonDetail(for: 1)
            
            XCTFail("Not Expected Result")
        } catch(let error as ErrorResponse) {
            XCTAssertEqual(error.status, 404)
        } catch {
            XCTAssertThrowsError(error)
        }
    }
    
    func test_catchPokemonAndLoad() throws {
        let sutTemp = PokemonStubRepository(isErrorRemote: false)
        try sutTemp.provideCatchPokemon(with: 0, nickname: "maggot", root: "fish")
        
        let data = try sutTemp.provideLoadMyPokemon()
        
        XCTAssertFalse(data.isEmpty)
    }
    
    func test_renamePokemonAndLoad() throws {
        let sutTemp = PokemonStubRepository(isErrorRemote: false)
        try sutTemp.provideCatchPokemon(with: 0, nickname: "maggot", root: "fish")
        
        try sutTemp.provideRenamePokemon(from: "maggot", to: "seven")
        
        let data = try sutTemp.provideLoadMyPokemon().first(where: { item in
            item.name.orEmpty().contains("seven")
        })
        
        XCTAssertEqual(data?.name, "seven-0")
    }
    
    func test_spesificDelete() throws {
        try sut.provideDeleteSpesificPokemon(at: "seven-0")
        
        let data = try sut.provideLoadMyPokemon()
        
        XCTAssertTrue(data.isEmpty)
    }
    
    func test_deleteAll() throws {
        try sut.provideDeleteAllPokemon()
        
        let data = try sut.provideLoadMyPokemon()
        
        XCTAssertTrue(data.isEmpty)
    }
}
