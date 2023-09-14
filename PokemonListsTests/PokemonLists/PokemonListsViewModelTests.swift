//
//  PokemonListsTests.swift
//  PokemonListsTests
//
//  Created by Gus Adi on 13/09/23.
//

import XCTest
@testable import PokemonLists

final class PokemonListsViewModelTests: XCTestCase {

    private let sut = PokemonListsViewModel()
    
    func test_decreaseOffsetPokemon() throws {
        Task {
            sut.currentOffset = 1
            await sut.decreaseOffset()
            
            XCTAssertEqual(sut.currentOffset, 0)
        }
    }
    
    func test_increaseOffsetPokemon() throws {
        Task {
            await sut.increaseOffset()
            
            XCTAssertEqual(sut.currentOffset, 1)
        }
    }

    func test_getPokemonList() throws {
        Task {
            await sut.getPokemonList()
            
            XCTAssertFalse((sut.phase.resultValue ?? []).isEmpty)
        }
    }
    
    func test_getFirstItem() throws {
        Task {
            await sut.getPokemonList()
            XCTAssertNotNil(sut.firstItem())
        }
    }
    
    func test_getFirstItemId() throws {
        Task {
            await sut.getPokemonList()
            XCTAssertEqual(sut.getIdForFirstItem(), 1)
        }
    }
    
    func test_getIdOnly() throws {
        Task {
            await sut.getPokemonList()
            guard let pokemon = sut.phase.resultValue?.randomElement() else { return }
            XCTAssertNotEqual(sut.getIdOnly(for: pokemon), 0)
        }
    }
}
