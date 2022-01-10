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
        await cloud.finish(steps: 0, metres: 0, tiles: [.init(x: 0, y: 0)])
        let model = await cloud.model
        XCTAssertTrue(model.walks.isEmpty)
        XCTAssertTrue(model.tiles.isEmpty)
    }
    
    func testFinish() async {
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -1).timestamp))
        await cloud.finish(steps: 3, metres: 5, tiles: [.init(x: 99, y: 77)])
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
        XCTAssertEqual(1, model.tiles.count)
        XCTAssertEqual(1, model.walks.first?.duration)
        XCTAssertEqual(3, model.walks.first?.steps)
        XCTAssertEqual(5, model.walks.first?.metres)
        XCTAssertEqual(.init(x: 99, y: 77), model.tiles.first)
    }
    
    func testFinishTiles() async {
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -2).timestamp))
        await cloud.finish(steps: 0, metres: 0, tiles: [.init(x: 99, y: 77)])
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -1).timestamp))
        await cloud.finish(steps: 0, metres: 0, tiles: [.init(x: 77, y: 99)])
        let model = await cloud.model
        XCTAssertTrue(model.tiles.contains(.init(x: 99, y: 77)))
        XCTAssertTrue(model.tiles.contains(.init(x: 77, y: 99)))
    }
    
    func testFinishLongWalk() async {
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSince1970: 0).timestamp))
        await cloud.finish(steps: 65540, metres: 65541, tiles: [.init(x: 99, y: 77)])
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
        XCTAssertEqual(1, model.tiles.count)
        XCTAssertEqual(3600, model.walks.first?.duration)
        XCTAssertEqual(65535, model.walks.first?.steps)
        XCTAssertEqual(65535, model.walks.first?.metres)
        XCTAssertEqual(.init(x: 99, y: 77), model.tiles.first)
    }
    
    func testFinishNotWalking() async {
        await cloud.add(
            walk: .init(timestamp: Date(timeIntervalSinceNow: -200).timestamp,
                        duration: 100,
                        steps: 34,
                        metres: 65))
        await cloud.finish(steps: 3, metres: 5, tiles: [.init(x: 99, y: 77)])
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
        XCTAssertTrue(model.tiles.isEmpty)
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
}
