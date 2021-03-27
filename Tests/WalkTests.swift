import XCTest
@testable import Hero

final class WalkTests: XCTestCase {
    func testEnd() {
        XCTAssertEqual(100,
                       Int(Walk(date: .init(timeIntervalSinceNow: -100))
                            .end(steps: 0, metres: 0)
                            .duration))
    }
    
    func testEndAfter9Hours() {
        let start = Calendar.current.date(byAdding: .hour, value: -(Constants.walk.duration.max + 1), to: .init())!
        XCTAssertEqual(Int(start.timeIntervalSince(Calendar.current.date(byAdding: .hour, value: -Constants.walk.duration.fallback, to: start)!)),
                       Int(Walk(date: start)
                            .end(steps: 0, metres: 0)
                            .duration))
    }
    
    func testActive() {
        XCTAssertTrue(Walk().active)
        XCTAssertFalse(Walk(date: .init(timeIntervalSinceNow: -1), duration: 1).active)
    }
}
