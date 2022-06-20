import XCTest
@testable import Hero

final class ChartTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testEmpty() {
        XCTAssertEqual(0, archive.chart.walks)
        XCTAssertEqual(0, archive.chart.steps.total)
    }
    
    func testMax() {
        archive.walks.append(.init(timestamp: 0, steps: 1))
        XCTAssertEqual(1, archive.chart.steps.max)
        archive.walks.append(.init(timestamp: 0, steps: 5))
        XCTAssertEqual(5, archive.chart.steps.max)
        archive.walks.append(.init(timestamp: 0, steps: 3))
        XCTAssertEqual(5, archive.chart.steps.max)
    }
    
    func testTotal() {
        archive.walks.append(.init(timestamp: 0, steps: 1))
        archive.walks.append(.init(timestamp: 0, steps: 5))
        archive.walks.append(.init(timestamp: 0, steps: 3))
        XCTAssertEqual(9, archive.chart.steps.total)
    }
    
    func testStepsZero() {
        archive.walks = [
            .init(timestamp: 0, duration: 1, steps: 0),
            .init(timestamp: 0, duration: 1, steps: 0),
            .init(timestamp: 0, duration: 1, steps: 0)]
        XCTAssertEqual(0, archive.chart.steps.max)
    }
    
    func testAverage() {
        archive.walks.append(.init(timestamp: 0, steps: 1))
        XCTAssertEqual(1, archive.chart.steps.average)
        archive.walks.append(.init(timestamp: 0, steps: 5))
        XCTAssertEqual(3, archive.chart.steps.average)
        archive.walks.append(.init(timestamp: 0, steps: 3))
        XCTAssertEqual(3, archive.chart.steps.average)
    }
    
    func testTrend() {
        XCTAssertEqual(.stable, archive.chart.steps.trend)
        archive.walks.append(.init(timestamp: 0, steps: 4))
        XCTAssertEqual(.stable, archive.chart.steps.trend)
        archive.walks.append(.init(timestamp: 0, steps: 4))
        XCTAssertEqual(.stable, archive.chart.steps.trend)
        archive.walks.append(.init(timestamp: 0, steps: 6))
        XCTAssertEqual(.increase, archive.chart.steps.trend)
        archive.walks.append(.init(timestamp: 0, steps: 1))
        XCTAssertEqual(.decrease, archive.chart.steps.trend)
    }
    
    func testIgnoreZero() {
        archive.walks.append(.init(timestamp: 0, steps: 0))
        archive.walks.append(.init(timestamp: 0, steps: 0))
        archive.walks.append(.init(timestamp: 0, steps: 10))
        XCTAssertEqual(10, archive.chart.steps.average)
        XCTAssertEqual(.stable, archive.chart.steps.trend)
    }
}
