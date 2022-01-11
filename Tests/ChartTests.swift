import XCTest
@testable import Hero

final class ChartTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testEmpty() {
        XCTAssertEqual(.zero, archive.steps)
        XCTAssertEqual(.zero, archive.metres)
    }
    
    func testMax() {
        archive.walks.append(.init(timestamp: 0, steps: 1))
        XCTAssertEqual(1, archive.steps.max)
        archive.walks.append(.init(timestamp: 0, steps: 5))
        XCTAssertEqual(5, archive.steps.max)
        archive.walks.append(.init(timestamp: 0, steps: 3))
        XCTAssertEqual(5, archive.steps.max)
    }
    
    func testStepsZero() {
        archive.walks = [
            .init(timestamp: 0, duration: 1, steps: 0),
            .init(timestamp: 0, duration: 1, steps: 0),
            .init(timestamp: 0, duration: 1, steps: 0)]
        XCTAssertEqual([
                        0,
                        0,
                        0], archive.steps.values)
        XCTAssertEqual(0, archive.steps.max)
    }
    
    func testAverage() {
        archive.walks.append(.init(timestamp: 0, steps: 1))
        XCTAssertEqual(1, archive.steps.average)
        archive.walks.append(.init(timestamp: 0, steps: 5))
        XCTAssertEqual(3, archive.steps.average)
        archive.walks.append(.init(timestamp: 0, steps: 3))
        XCTAssertEqual(3, archive.steps.average)
    }
}
