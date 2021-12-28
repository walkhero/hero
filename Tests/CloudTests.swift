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
}
