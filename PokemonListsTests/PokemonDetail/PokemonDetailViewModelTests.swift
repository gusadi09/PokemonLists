//
//  PokemonDetailViewModelTests.swift
//  PokemonListsTests
//
//  Created by Gus Adi on 13/09/23.
//

import XCTest
@testable import PokemonLists

final class PokemonDetailViewModelTests: XCTestCase {
    private let sut = PokemonDetailViewModel()
    
    func test_getDetail() throws {
        Task {
            await sut.getPokemonDetail(for: 1)
            
            XCTAssertNotNil(sut.phase.resultValue?.name)
        }
    }
}
