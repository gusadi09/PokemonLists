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
    
    func test_getMovesArray_prefixed() throws {
        Task {
            await sut.getPokemonDetail(for: 1)
            
            XCTAssertEqual(sut.movesArray().count, 20)
        }
    }
    
    func test_getMovesArray_all() throws {
        Task {
            await sut.getPokemonDetail(for: 1)
            
            await sut.showMoreMoveToggle()
            
            XCTAssertNotEqual(sut.movesArray().count, 20)
        }
    }
    
    func test_toggleShowMore() throws {
        Task {
            await sut.showMoreMoveToggle()
            XCTAssertTrue(sut.showMoreMoves)
        }
    }
    
    func test_showTextLess() throws {
        Task {
            await sut.showMoreMoveToggle()
            XCTAssertEqual(sut.showText(), LocalizableText.detailShowLess)
        }
    }
    
    func test_showTextMore() throws {
        Task {
            XCTAssertEqual(sut.showText(), LocalizableText.detailShowMore)
        }
    }
    
    func test_getPictureText() throws {
        Task {
            await sut.getPokemonDetail(for: 1)
            
            XCTAssertNotNil(sut.picture())
        }
    }
}
