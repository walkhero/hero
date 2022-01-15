import XCTest
@testable import Archivable
@testable import Hero

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    
    override func setUp() {
        cloud = .ephemeral
    }
    
    func testStartNew() async {
        await cloud.start()
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
    }
    
    func testStart() async {
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -100).timestamp, duration: 1))
        await cloud.start()
        let model = await cloud.model
        XCTAssertEqual(2, model.walks.count)
    }
    
    func testStartAlreadyWalking() async {
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -100).timestamp))
        await cloud.start()
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
    }
    
    func testFinishNoDuration() async {
        await cloud.start()
        _ = await cloud.finish(steps: 0, metres: 0, tiles: [.init(x: 0, y: 0)])
        let model = await cloud.model
        XCTAssertTrue(model.walks.isEmpty)
        XCTAssertTrue(model.squares.isEmpty)
    }
    
    func testFinish() async {
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -1).timestamp))
        _ = await cloud.finish(steps: 3, metres: 5, tiles: [.init(x: 99, y: 77)])
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
        XCTAssertEqual(1, model.squares.count)
        XCTAssertEqual(1, model.walks.first?.duration)
        XCTAssertEqual(3, model.walks.first?.steps)
        XCTAssertEqual(5, model.walks.first?.metres)
        XCTAssertEqual(.init(x: 99, y: 77), model.squares.first)
    }
    
    func testFinishTiles() async {
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -2).timestamp))
        _ = await cloud.finish(steps: 0, metres: 0, tiles: [.init(x: 99, y: 77)])
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -1).timestamp))
        _ = await cloud.finish(steps: 0, metres: 0, tiles: [.init(x: 77, y: 99)])
        let model = await cloud.model
        XCTAssertTrue(model.squares.contains(.init(x: 99, y: 77)))
        XCTAssertTrue(model.squares.contains(.init(x: 77, y: 99)))
    }
    
    func testFinishLongWalk() async {
        _ = await cloud.add(walk: .init(timestamp: Date(timeIntervalSince1970: 0).timestamp))
        _ = await cloud.finish(steps: 65540, metres: 65541, tiles: [.init(x: 99, y: 77)])
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
        XCTAssertEqual(1, model.squares.count)
        XCTAssertEqual(3600, model.walks.first?.duration)
        XCTAssertEqual(65535, model.walks.first?.steps)
        XCTAssertEqual(65535, model.walks.first?.metres)
        XCTAssertEqual(.init(x: 99, y: 77), model.squares.first)
    }
    
    func testFinishNotWalking() async {
        await cloud.add(
            walk: .init(timestamp: Date(timeIntervalSinceNow: -200).timestamp,
                        duration: 100,
                        steps: 34,
                        metres: 65))
        _ = await cloud.finish(steps: 3, metres: 5, tiles: [.init(x: 99, y: 77)])
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
        XCTAssertTrue(model.squares.isEmpty)
        XCTAssertEqual(100, model.walks.first?.duration)
        XCTAssertEqual(34, model.walks.first?.steps)
        XCTAssertEqual(65, model.walks.first?.metres)
    }
    
    func testCancelNotStarted() async {
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -200).timestamp, duration: 100))
        await cloud.cancel()
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
    }
    
    func testCancel() async {
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: 0).timestamp))
        await cloud.cancel()
        let model = await cloud.model
        XCTAssertTrue(model.walks.isEmpty)
    }
    
    func testSummary() async {
        let yesterday = Calendar.global.date(byAdding: .day, value: -1, to: .now)!
        await cloud.add(walk: .init(timestamp: yesterday.timestamp))
        
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -20).timestamp))
        _ = await cloud.finish(steps: 0, metres: 0, tiles: [.init(x: 99, y: 76)])
        
        let date = Date(timeIntervalSinceNow: -2)
        await cloud.add(walk: .init(timestamp: date.timestamp))
        let summary = await cloud.finish(steps: 3, metres: 5, tiles: [
            .init(x: 99, y: 77),
            .init(x: 99, y: 76)])
        
        XCTAssertEqual(date.timestamp, summary?.started.timestamp)
        XCTAssertEqual(3, summary?.steps)
        XCTAssertEqual(5, summary?.metres)
        XCTAssertEqual(1, summary?.squares)
        XCTAssertEqual(2, summary?.streak)
    }
}
