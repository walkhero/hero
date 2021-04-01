import XCTest
@testable import Hero

final class DateIntervalTests: XCTestCase {
    func testRangeYear() {
        let firstDayOfMonth = Calendar.current.date(from: .init(year: 2021, month: 1, day: 1))!
        let interval = DateInterval(start: firstDayOfMonth, duration: 0)
        _ = interval.months(year: 2021) {
            XCTAssertEqual(1, $0)
            XCTAssertNotNil($1)
        }
    }
    
    func testRangeMonth() {
        let firstDayOfMonth = Calendar.current.date(from: .init(year: 2021, month: 4, day: 1))!
        let interval = DateInterval(start: firstDayOfMonth, duration: 0)
        _ = interval.months(year: 2021) {
            XCTAssertEqual(4, $0)
            XCTAssertNotNil($1)
        }
    }
}
