import XCTest
@testable import Hero

final class DateIntervalTests: XCTestCase {
    func testRangeYear() {
        let firstDayOfMonth = Calendar.current.date(from: .init(year: 2021, month: 1, day: 1))!
        let interval = DateInterval(start: firstDayOfMonth, duration: 1)
        _ = interval.months(year: 2021) {
            XCTAssertEqual(1, $0)
            XCTAssertNotNil($1)
        }
    }
    
    func testMultipleYears() {
        let start = Calendar.current.date(from: .init(year: 2020, month: 12, day: 31))!
        let end = Calendar.current.date(from: .init(year: 2021, month: 1, day: 1))!
        let interval = DateInterval(start: start, end: end)
        _ = interval.years { year, interval in
            interval.months(year: year) { month, interval in
                if year == 2020 {
                    XCTAssertEqual(12, month)
                }
            }
        }
    }
    
    func testRangeMonth() {
        let firstDayOfMonth = Calendar.current.date(from: .init(year: 2008, month: 4, day: 1))!
        let interval = DateInterval(start: firstDayOfMonth, duration: 1)
        _ = interval.years { year, interval in
            _ = interval.months(year: year) {
                XCTAssertEqual(4, $0)
                XCTAssertNotNil($1)
            }
        }
    }
}
