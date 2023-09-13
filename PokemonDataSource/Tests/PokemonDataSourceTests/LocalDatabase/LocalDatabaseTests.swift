import XCTest
@testable import PokemonDataSource

final class LocalDatabaseTests: XCTestCase {

    func test_addNewEntity_loadAll() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let persistence = CoreDataManager()
        
        try persistence.savePokemon(name: "fish")
        
        XCTAssertFalse(try persistence.loadPokemon().isEmpty)
    }
    
    func test_addTwoEntity_deleteSpesificEntity() throws {
        let persistence = CoreDataManager()
        
        try persistence.deleteAllPokemon()
        
        try persistence.savePokemon(name: "fox")
        
        try persistence.savePokemon(name: "crocodile")
        
        try persistence.deletePokemon(name: "fox")
        
        let pokemon = try persistence.loadPokemon()
        
        XCTAssertEqual(pokemon.count, 1)
        XCTAssertTrue(pokemon.filter({ item in
            item.name == "fox"
        }).isEmpty)
    }
    
    func test_deleteAllEntity() throws {
        let persistence = CoreDataManager()
        
        try persistence.deleteAllPokemon()
        
        let pokemon = try persistence.loadPokemon()
        
        XCTAssertTrue(pokemon.isEmpty)
    }

}
