import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(JsonCodableMacroPlugin)
import JsonCodableMacroPlugin
import JsonCodableMacroClient

let testMacros: [String: Macro.Type] = [
    "JsonCodable": JsonCodableMacro.self,
]
#endif

final class JsonCodableMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(JsonCodableMacroPlugin)
        assertMacroExpansion(
            """
            @JsonCodable
            class Person: Codable {
                let name: String
                let age: Int
                let birthday: Date?
            }
            """,
            expandedSource:
            """
            class Person: Codable {
                let name: String
                let age: Int
                let birthday: Date?
            
                init(
                    name: String,
                    age: Int,
                    birthday: Date?
                ) {
                    self.name = name
                    self.age = age
                    self.birthday = birthday
                }
            
                public func toJson() -> String? {
                    let encoder = JSONEncoder()
                    guard let data = try? encoder.encode(self) else {
                        return nil
                    }
                    return String(data: data, encoding: .utf8)
                }
            
                public func fromJson(_ json: String) -> Self? {
                    let decoder = JSONDecoder()
                    guard let data = json.data(using: .utf8),
                          let object = try? decoder.decode(Self.self, from: data) else {
                        return nil
                    }
                    return object
                }
            
                public enum CodingKeys: String, CodingKey {
                    case name = "name"
                    case age = "age"
                    case birthday = "birthday"
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testBookMacro() throws {
        #if canImport(JsonCodableMacroPlugin)
        assertMacroExpansion(
            """
            @JsonCodable
            struct Book: Codable {
                let title: String
                let author: String
                let publishedYear: Int
            }
            """,
            expandedSource:
            """
            struct Book: Codable {
                let title: String
                let author: String
                let publishedYear: Int
            
                init(
                    title: String,
                    author: String,
                    publishedYear: Int
                ) {
                    self.title = title
                    self.author = author
                    self.publishedYear = publishedYear
                }
            
                public func toJson() -> String? {
                    let encoder = JSONEncoder()
                    guard let data = try? encoder.encode(self) else {
                        return nil
                    }
                    return String(data: data, encoding: .utf8)
                }
            
                public func fromJson(_ json: String) -> Self? {
                    let decoder = JSONDecoder()
                    guard let data = json.data(using: .utf8),
                          let object = try? decoder.decode(Self.self, from: data) else {
                        return nil
                    }
                    return object
                }
            
                public enum CodingKeys: String, CodingKey {
                    case title = "title"
                    case author = "author"
                    case publishedYear = "published_year"
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testLibraryMacro() throws {
        #if canImport(JsonCodableMacroPlugin)
        assertMacroExpansion(
            """
            @JsonCodable
            struct Library: Codable {
                let name: String
                let books: [Book]
            }
            """,
            expandedSource:
            """
            struct Library: Codable {
                let name: String
                let books: [Book]
            
                init(
                    name: String,
                    books: [Book]
                ) {
                    self.name = name
                    self.books = books
                }
            
                public func toJson() -> String? {
                    let encoder = JSONEncoder()
                    guard let data = try? encoder.encode(self) else {
                        return nil
                    }
                    return String(data: data, encoding: .utf8)
                }
            
                public func fromJson(_ json: String) -> Self? {
                    let decoder = JSONDecoder()
                    guard let data = json.data(using: .utf8),
                          let object = try? decoder.decode(Self.self, from: data) else {
                        return nil
                    }
                    return object
                }
            
                public enum CodingKeys: String, CodingKey {
                    case name = "name"
                    case books = "books"
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    

//    func testToJsonAndFromJson() throws {
//        let person = Person(name: "koichi", age: 21, birthday: nil)
//        let json = person.toJson()
//        XCTAssertNotNil(json)
//        if let json = json {
//            let decodedPerson = Person.fromJson(json)
//            XCTAssertNotNil(decodedPerson)
//            XCTAssertEqual(decodedPerson?.name, "koichi")
//            XCTAssertEqual(decodedPerson?.age, 21)
//            XCTAssertNil(decodedPerson?.birthday)
//        }
//
//        let book = Book(title: "Swift Programming", author: "Apple", publishedYear: 2021)
//        let bookJson = book.toJson()
//        XCTAssertNotNil(bookJson)
//        if let bookJson = bookJson {
//            let decodedBook = Book.fromJson(bookJson)
//            XCTAssertNotNil(decodedBook)
//            XCTAssertEqual(decodedBook?.title, "Swift Programming")
//            XCTAssertEqual(decodedBook?.author, "Apple")
//            XCTAssertEqual(decodedBook?.publishedYear, 2021)
//        }
//
//        let library = Library(name: "City Library", books: [book])
//        let libraryJson = library.toJson()
//        XCTAssertNotNil(libraryJson)
//        if let libraryJson = libraryJson {
//            let decodedLibrary = Library.fromJson(libraryJson)
//            XCTAssertNotNil(decodedLibrary)
//            XCTAssertEqual(decodedLibrary?.name, "City Library")
//            XCTAssertEqual(decodedLibrary?.books.count, 1)
//            XCTAssertEqual(decodedLibrary?.books.first?.title, "Swift Programming")
//        }
//    }
}
