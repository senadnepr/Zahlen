import XCTest
@testable import Zahlen

final class NumberToGermanConverterTests: XCTestCase {
    
    let converter = NumberToGermanConverter.shared

    func testSingleDigits() {
        XCTAssertEqual(converter.convert(number: 0), "null")
        XCTAssertEqual(converter.convert(number: 1), "eins")
        XCTAssertEqual(converter.convert(number: 2), "zwei")
        XCTAssertEqual(converter.convert(number: 8), "acht")
    }
    
    func testTeens() {
        XCTAssertEqual(converter.convert(number: 10), "zehn")
        XCTAssertEqual(converter.convert(number: 11), "elf")
        XCTAssertEqual(converter.convert(number: 12), "zwölf")
        XCTAssertEqual(converter.convert(number: 16), "sechzehn")
        XCTAssertEqual(converter.convert(number: 17), "siebzehn")
    }
    
    func testTens() {
        XCTAssertEqual(converter.convert(number: 20), "zwanzig")
        XCTAssertEqual(converter.convert(number: 30), "dreißig")
        XCTAssertEqual(converter.convert(number: 50), "fünfzig")
    }
    
    func testTwoDigits() {
        XCTAssertEqual(converter.convert(number: 21), "einundzwanzig")
        XCTAssertEqual(converter.convert(number: 35), "fünfunddreißig")
        XCTAssertEqual(converter.convert(number: 99), "neunundneunzig")
    }
    
    func testHundreds() {
        XCTAssertEqual(converter.convert(number: 100), "einhundert")
        XCTAssertEqual(converter.convert(number: 101), "einhunderteins")
        XCTAssertEqual(converter.convert(number: 115), "einhundertfünfzehn")
        XCTAssertEqual(converter.convert(number: 234), "zweihundertvierunddreißig")
        XCTAssertEqual(converter.convert(number: 999), "neunhundertneunundneunzig")
    }
    
    func testThousands() {
        XCTAssertEqual(converter.convert(number: 1000), "eintausend")
        XCTAssertEqual(converter.convert(number: 1005), "eintausendfünf")
        XCTAssertEqual(converter.convert(number: 1234), "eintausendzweihundertvierunddreißig")
        XCTAssertEqual(converter.convert(number: 5000), "fünftausend")
        XCTAssertEqual(converter.convert(number: 9999), "neuntausendneunhundertneunundneunzig")
    }
    
    func testTime() {
        XCTAssertEqual(converter.convert(hour: 14, minute: 30), "vierzehn Uhr dreißig")
        XCTAssertEqual(converter.convert(hour: 0, minute: 0), "null Uhr")
        XCTAssertEqual(converter.convert(hour: 23, minute: 59), "dreiundzwanzig Uhr neunundfünfzig")
    }
    
    func testDates() {
        // "einundzwanzigster März zweitausendvierundzwanzig"
        XCTAssertEqual(converter.convert(day: 21, month: 3, year: 2024), "einundzwanzigster März zweitausendvierundzwanzig")
        
        // "erster Januar neunzehnhundertneunundneunzig"
        XCTAssertEqual(converter.convert(day: 1, month: 1, year: 1999), "erster Januar neunzehnhundertneunundneunzig")
        
        // "fünfter Dezember zwanzig" (simplistic fallback for year 20 if needed, but year operates logically)
        XCTAssertEqual(converter.convert(day: 5, month: 12, year: 2025), "fünfter Dezember zweitausendfünfundzwanzig")
    }
}
