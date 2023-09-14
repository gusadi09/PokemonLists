import XCTest
@testable import PokemonDataSource

final class LocalDatabaseTests: XCTestCase {

    func test_addNewEntity_loadAll() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let persistence = PokemonCoreDataManager()
        
        try persistence.savePokemon(id: 1, name: "fish", root: "fish")
        
        XCTAssertFalse(try persistence.loadPokemon().isEmpty)
    }
    
    func test_addTwoEntity_deleteSpesificEntity() throws {
        let persistence = PokemonCoreDataManager()
        
        try persistence.deleteAllPokemon()
        
        try persistence.savePokemon(id: 1, name: "fox", root: "fox")
        
        try persistence.savePokemon(id: 2, name: "crocodile", root: "ampifibi")
        
        try persistence.deletePokemon(name: "fox")
        
        let pokemon = try persistence.loadPokemon()
        
        XCTAssertEqual(pokemon.count, 1)
        XCTAssertTrue(pokemon.filter({ item in
            item.name == "fox"
        }).isEmpty)
    }

    func test_fibonacciNumber() throws {
        let persistence = PokemonCoreDataManager()
        
        XCTAssertEqual(persistence.fibonacciSeries(num: 2), 1)
    }
    
    func test_editEntity() throws {
        let persistence = PokemonCoreDataManager()
        
        try persistence.savePokemon(id: 1, name: "fish", root: "fish")
        
        try persistence.editPokemon(name: "fish", newValue: "fox")
        
        let data = try persistence.loadPokemon()
        
        XCTAssertEqual(data.first(where: { item in
            item.name.orEmpty().contains("fox")
        })?.name, "fox-0")
    }
    
    func test_deleteAllEntity() throws {
        let persistence = PokemonCoreDataManager()
        
        try persistence.deleteAllPokemon()
        
        let pokemon = try persistence.loadPokemon()
        
        XCTAssertTrue(pokemon.isEmpty)
    }
}
