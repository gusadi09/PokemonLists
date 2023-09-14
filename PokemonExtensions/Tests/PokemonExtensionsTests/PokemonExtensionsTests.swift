import XCTest
@testable import PokemonExtensions

final class PokemonExtensionsTests: XCTestCase {
    
    struct DummyStruct: Codable {
        let name: String
    }
    
    func test_stringOrEmpty() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let string: String? = nil
        
        XCTAssertEqual(string.orEmpty(), "")
    }
    
    func test_stringToUrl() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let url = "http://www.google.com"
        
        XCTAssertEqual(url.toURL(), URL(string: "http://www.google.com"))
    }
    
    func test_boolOrFalse() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let bool: Bool? = nil
        
        XCTAssertEqual(bool.orFalse(), false)
    }
    
    func test_intOrZero() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let int: Int? = nil
        
        XCTAssertEqual(int.orZero(), 0)
    }
    
    func test_uintOrZero() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let uint: UInt? = nil
        
        XCTAssertEqual(uint.orZero(), 0)
    }
    
    func test_doubleOrZero() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let double: Double? = nil
        
        XCTAssertEqual(double.orZero(), 0.0)
    }
    
    func test_encodableToData() throws {
        let data = ["name": "test"]
        
        XCTAssertEqual(String(data: data.toData(), encoding: .utf8), "{\"name\":\"test\"}")
    }
    
    func test_encodableToJSON() throws {
        let dummy = DummyStruct(name: "test")
        
        XCTAssertEqual(dummy.toJSON()["name"] as? String, "test")
    }
}
