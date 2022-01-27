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
}
