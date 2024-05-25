import Foundation
import JsonCodableMacro

@JsonCodable
public class Person: Codable {
  let name: String
  let age: Int
  let birthday: Date?
}

@JsonCodable
public struct Book: Codable {
    var title: String
    var author: String
    var publishedYear: Int
}

@JsonCodable
public struct Library: Codable {
    var name: String
    var books: [Book]
}

let calendar = Calendar.current
let date = calendar.date(from: DateComponents(year: 2021, month: 3, day: 1))

let person = Person(name: "Bob", age: 21, birthday: date)

// DateFormatter を使用して適切なタイムゾーンを設定
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"
dateFormatter.timeZone = TimeZone.current

if let birthday = person.birthday {
    let birthdayString = dateFormatter.string(from: birthday)
    print("Name: \(person.name), Age: \(person.age), Birthday: \(birthdayString)")
}

if let json = person.toJson() {
    print(json)
    if let decodedPerson = person.fromJson(json) {
        if let birthday = decodedPerson.birthday {
            let birthdayString = dateFormatter.string(from: birthday)
            print("Name: \(decodedPerson.name), Age: \(decodedPerson.age), Birthday: \(birthdayString)")
        }
    }
}

let book = Book(title: "Swift Programming", author: "Apple", publishedYear: 2021)
if let bookJson = book.toJson() {
    print(bookJson)
    if let decodedBook = book.fromJson(bookJson) {
        print("Title: \(decodedBook.title), Author: \(decodedBook.author), Published Year: \(decodedBook.publishedYear)")
    }
}

let library = Library(name: "City Library", books: [book])
if let libraryJson = library.toJson() {
    print(libraryJson)
    if let decodedLibrary = library.fromJson(libraryJson) {
        print("Library Name: \(decodedLibrary.name), Books: \(decodedLibrary.books.map { $0.title }.joined(separator: ", "))")
    }
}
