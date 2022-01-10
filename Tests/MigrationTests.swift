import XCTest
@testable import Archivable
@testable import Hero

final class MigrationTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var directory: URL!
    private var file: URL!
    
    override func setUp() {
        cloud = .ephemeral
        directory = URL(fileURLWithPath: NSTemporaryDirectory())
        file = directory.appendingPathComponent("WalkHero.archive")
        try! Data(contentsOf: Bundle.module.url(forResource: "WalkHero", withExtension: "archive")!)
            .write(to: file)
    }
    
    func testParse() async {
        XCTAssertTrue(FileManager.default.fileExists(atPath: file.path))
        await cloud.migrate(directory: directory)
        let walks = await cloud.model.walks
        XCTAssertFalse(walks.isEmpty)
        XCTAssertFalse(FileManager.default.fileExists(atPath: file.path))
    }
    
    func testStreak() async {
        await cloud.migrate(directory: directory)
        let streak = await cloud.model.calendar.streak
        XCTAssertEqual(269, streak.maximum)
        XCTAssertEqual(269, streak.current)
    }
    
    func testMap() async {
        await cloud.migrate(directory: directory)
        let tiles = await cloud.model.tiles
        XCTAssertEqual(12_729, tiles.count)
    }
    
    func testWalks() async {
        let timezone = Calendar.global.timeZone

        let berlin = TimeZone(identifier: "Europe/Berlin")!
        Calendar.global.timeZone = berlin
        
        await cloud.migrate(directory: directory)
        let walks = await cloud.model.walks
        walks
            .forEach {
                XCTAssertEqual(3600, $0.offset)
                XCTAssertGreaterThan($0.duration, 0)
                XCTAssertGreaterThan($0.timestamp, 0)
            }
        
        Calendar.global.timeZone = timezone
    }
}
