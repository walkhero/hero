import XCTest
@testable import Archivable
@testable import Hero

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testStartNew() async {
        let timestamp = Date().timestamp
        var model = await cloud.model
        XCTAssertEqual(0, model.walking)
        await cloud.start()
        model = await cloud.model
        XCTAssertLessThanOrEqual(timestamp, model.walking)
    }
    
    func testStartAlreadyWalking() async {
        await cloud.walking(timestamp: 123)
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -100).timestamp))
        await cloud.start()
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
        XCTAssertEqual(123, model.walking)
    }
    
    func testFinishNoDuration() async {
        await cloud.start()
        _ = await cloud.finish(duration: 0, steps: 0, metres: 0, calories: 0, squares: [.init(x: 0, y: 0)])
        let model = await cloud.model
        XCTAssertTrue(model.walks.isEmpty)
        XCTAssertTrue(model.tiles.isEmpty)
        XCTAssertEqual(0, model.walking)
    }
    
    func testFinish() async {
        await cloud.walking(timestamp: Date(timeIntervalSinceNow: -1).timestamp)
        _ = await cloud.finish(duration: 1, steps: 3, metres: 5, calories: 2, squares: [.init(x: 99, y: 77)])
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
        XCTAssertEqual(1, model.tiles.count)
        XCTAssertEqual(1, model.walks.first?.duration)
        XCTAssertEqual(3, model.walks.first?.steps)
        XCTAssertEqual(5, model.walks.first?.metres)
        XCTAssertEqual(2, model.walks.first?.calories)
        XCTAssertEqual(0, model.walking)
        XCTAssertEqual(Squares.Item(x: 99, y: 77), model.tiles.first)
    }
    
    func testFinishTiles() async {
        await cloud.walking(timestamp: Date(timeIntervalSinceNow: -2).timestamp)
        _ = await cloud.finish(duration: 2, steps: 0, metres: 0, calories: 0, squares: [.init(x: 99, y: 77)])
        await cloud.walking(timestamp: Date(timeIntervalSinceNow: -1).timestamp)
        _ = await cloud.finish(duration: 1, steps: 0, metres: 0, calories: 0, squares: [.init(x: 77, y: 99)])
        let tiles = await cloud.model.tiles
        XCTAssertTrue(tiles.contains(.init(x: 99, y: 77)))
        XCTAssertTrue(tiles.contains(.init(x: 77, y: 99)))
    }
    
    func testFinishLongWalk() async {
        _ = await cloud.walking(timestamp: Date(timeIntervalSince1970: 1).timestamp)
        _ = await cloud.finish(duration: 3600, steps: 65540, metres: 65541, calories: 324324232342322432, squares: [.init(x: 99, y: 77)])
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
        XCTAssertEqual(1, model.tiles.count)
        XCTAssertEqual(3600, model.walks.first?.duration)
        XCTAssertEqual(65535, model.walks.first?.steps)
        XCTAssertEqual(65535, model.walks.first?.metres)
        XCTAssertEqual(4294967295, model.walks.first?.calories)
        XCTAssertEqual(.init(x: 99, y: 77), model.tiles.first)
    }
    
    func testFinishNotWalking() async {
        await cloud.add(
            walk: .init(timestamp: Date(timeIntervalSinceNow: -200).timestamp,
                        duration: 100,
                        steps: 34,
                        metres: 65,
                        calories: 67))
        _ = await cloud.finish(duration: 200, steps: 3, metres: 5, calories: 2, squares: [.init(x: 99, y: 77)])
        let model = await cloud.model
        XCTAssertEqual(0, model.walking)
        XCTAssertEqual(1, model.walks.count)
        XCTAssertTrue(model.tiles.isEmpty)
        XCTAssertEqual(100, model.walks.first?.duration)
        XCTAssertEqual(34, model.walks.first?.steps)
        XCTAssertEqual(65, model.walks.first?.metres)
        XCTAssertEqual(67, model.walks.first?.calories)
    }
    
    func testCancelNotStarted() async {
        await cloud.add(walk: .init(timestamp: Date(timeIntervalSinceNow: -200).timestamp, duration: 100))
        await cloud.cancel()
        let model = await cloud.model
        XCTAssertEqual(1, model.walks.count)
        XCTAssertEqual(0, model.walking)
    }
    
    func testCancel() async {
        await cloud.walking(timestamp: Date(timeIntervalSinceNow: 0).timestamp)
        await cloud.cancel()
        let model = await cloud.model
        XCTAssertTrue(model.walks.isEmpty)
        XCTAssertEqual(0, model.walking)
    }
}

private extension Cloud where Output == Archive {
    func walking(timestamp: UInt32) {
        model.walking = timestamp
    }
    
    func add(walk: Walk) {
        model.walks = model.walks + walk
    }
}
