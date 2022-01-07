import XCTest
@testable import Hero

final class CalendarTests: XCTestCase {
    func testDuration() {
        var timestamp = Date(timeIntervalSinceNow: -100).timestamp
        XCTAssertEqual(100, Calendar.current.duration(from: timestamp))
        
        timestamp = Date(timeIntervalSinceNow: -1000).timestamp
        XCTAssertEqual(1000, Calendar.current.duration(from: timestamp))
        
        timestamp = Calendar.current.date(byAdding: .hour, value: -9, to: .now)!.timestamp
        XCTAssertEqual(32400, Calendar.current.duration(from: timestamp))
        
        timestamp = Calendar.current.date(byAdding: .hour, value: -10, to: .now)!.timestamp
        XCTAssertEqual(3600, Calendar.current.duration(from: timestamp))
        
        timestamp = Calendar.current.date(byAdding: .hour, value: -1000, to: .now)!.timestamp
        XCTAssertEqual(3600, Calendar.current.duration(from: timestamp))
    }
    
    func testLeadingWeekdays() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        XCTAssertEqual(0, calendar.leadingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(1, calendar.leadingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(2, calendar.leadingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(3, calendar.leadingWeekdays(year: 2021, month: 8, day: 4))
        XCTAssertEqual(4, calendar.leadingWeekdays(year: 2021, month: 8, day: 5))
        XCTAssertEqual(5, calendar.leadingWeekdays(year: 2021, month: 8, day: 6))
        XCTAssertEqual(6, calendar.leadingWeekdays(year: 2021, month: 8, day: 7))
        XCTAssertEqual(0, calendar.leadingWeekdays(year: 2021, month: 8, day: 8))
        calendar.firstWeekday = 2
        XCTAssertEqual(6, calendar.leadingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(0, calendar.leadingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(1, calendar.leadingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(2, calendar.leadingWeekdays(year: 2021, month: 8, day: 4))
        XCTAssertEqual(3, calendar.leadingWeekdays(year: 2021, month: 8, day: 5))
        XCTAssertEqual(4, calendar.leadingWeekdays(year: 2021, month: 8, day: 6))
        XCTAssertEqual(5, calendar.leadingWeekdays(year: 2021, month: 8, day: 7))
        XCTAssertEqual(6, calendar.leadingWeekdays(year: 2021, month: 8, day: 8))
        calendar.firstWeekday = 3
        XCTAssertEqual(5, calendar.leadingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(6, calendar.leadingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(0, calendar.leadingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(1, calendar.leadingWeekdays(year: 2021, month: 8, day: 4))
        XCTAssertEqual(2, calendar.leadingWeekdays(year: 2021, month: 8, day: 5))
        XCTAssertEqual(3, calendar.leadingWeekdays(year: 2021, month: 8, day: 6))
        XCTAssertEqual(4, calendar.leadingWeekdays(year: 2021, month: 8, day: 7))
        XCTAssertEqual(5, calendar.leadingWeekdays(year: 2021, month: 8, day: 8))
        calendar.firstWeekday = 4
        XCTAssertEqual(4, calendar.leadingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(5, calendar.leadingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(6, calendar.leadingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(0, calendar.leadingWeekdays(year: 2021, month: 8, day: 4))
        XCTAssertEqual(1, calendar.leadingWeekdays(year: 2021, month: 8, day: 5))
        XCTAssertEqual(2, calendar.leadingWeekdays(year: 2021, month: 8, day: 6))
        XCTAssertEqual(3, calendar.leadingWeekdays(year: 2021, month: 8, day: 7))
        XCTAssertEqual(4, calendar.leadingWeekdays(year: 2021, month: 8, day: 8))
    }
    
    func testTrailingWeekdays() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        XCTAssertEqual(6, calendar.trailingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(5, calendar.trailingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(4, calendar.trailingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(3, calendar.trailingWeekdays(year: 2021, month: 8, day: 4))
        XCTAssertEqual(2, calendar.trailingWeekdays(year: 2021, month: 8, day: 5))
        XCTAssertEqual(1, calendar.trailingWeekdays(year: 2021, month: 8, day: 6))
        XCTAssertEqual(0, calendar.trailingWeekdays(year: 2021, month: 8, day: 7))
        XCTAssertEqual(6, calendar.trailingWeekdays(year: 2021, month: 8, day: 8))
        calendar.firstWeekday = 2
        XCTAssertEqual(0, calendar.trailingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(6, calendar.trailingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(5, calendar.trailingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(4, calendar.trailingWeekdays(year: 2021, month: 8, day: 4))
        XCTAssertEqual(3, calendar.trailingWeekdays(year: 2021, month: 8, day: 5))
        XCTAssertEqual(2, calendar.trailingWeekdays(year: 2021, month: 8, day: 6))
        XCTAssertEqual(1, calendar.trailingWeekdays(year: 2021, month: 8, day: 7))
        XCTAssertEqual(0, calendar.trailingWeekdays(year: 2021, month: 8, day: 8))
        calendar.firstWeekday = 3
        XCTAssertEqual(1, calendar.trailingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(0, calendar.trailingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(6, calendar.trailingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(5, calendar.trailingWeekdays(year: 2021, month: 8, day: 4))
        XCTAssertEqual(4, calendar.trailingWeekdays(year: 2021, month: 8, day: 5))
        XCTAssertEqual(3, calendar.trailingWeekdays(year: 2021, month: 8, day: 6))
        XCTAssertEqual(2, calendar.trailingWeekdays(year: 2021, month: 8, day: 7))
        XCTAssertEqual(1, calendar.trailingWeekdays(year: 2021, month: 8, day: 8))
        calendar.firstWeekday = 4
        XCTAssertEqual(2, calendar.trailingWeekdays(year: 2021, month: 8, day: 1))
        XCTAssertEqual(1, calendar.trailingWeekdays(year: 2021, month: 8, day: 2))
        XCTAssertEqual(0, calendar.trailingWeekdays(year: 2021, month: 8, day: 3))
        XCTAssertEqual(6, calendar.trailingWeekdays(year: 2021, month: 8, day: 4))
        XCTAssertEqual(5, calendar.trailingWeekdays(year: 2021, month: 8, day: 5))
        XCTAssertEqual(4, calendar.trailingWeekdays(year: 2021, month: 8, day: 6))
        XCTAssertEqual(3, calendar.trailingWeekdays(year: 2021, month: 8, day: 7))
        XCTAssertEqual(2, calendar.trailingWeekdays(year: 2021, month: 8, day: 8))
    }
    
    func testLeadingTrailingNewYear() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .init(identifier: "de_DE")
        XCTAssertEqual(5, calendar.leadingWeekdays(year: 2022, month: 1, day: 1))
    }
}
