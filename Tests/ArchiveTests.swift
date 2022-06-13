import XCTest
@testable import Archivable
@testable import Hero

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testParse() async {
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertTrue(archive.tiles.isEmpty)
        XCTAssertEqual(0, archive.walking)
        XCTAssertEqual(Display.Key.allCases.count, archive.display.items.count)
    }
    
    func testWalks() async {
        let date = Date(timeIntervalSinceNow: -1000)
        archive.walks = [.init(timestamp: 100, offset: -5, duration: 50, steps: 35, metres: 24, calories: 123456)]
        archive.walking = date.timestamp
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(100, archive.walks.first?.timestamp)
        XCTAssertEqual(-5, archive.walks.first?.offset)
        XCTAssertEqual(50, archive.walks.first?.duration)
        XCTAssertEqual(35, archive.walks.first?.steps)
        XCTAssertEqual(24, archive.walks.first?.metres)
        XCTAssertEqual(123456, archive.walks.first?.calories)
        XCTAssertEqual(date.timestamp, archive.walking)
    }
    
    func testTiles() async {
        archive.tiles = [.init(x: 456, y: 9870)]
        let tiles = await Archive.prototype(data: archive.compressed).tiles
        XCTAssertEqual(456, tiles.first?.x)
        XCTAssertEqual(9870, tiles.first?.y)
    }
    
    func testDisplay() async {
        archive.display.items = Display.Key.allCases.reversed().map { .init(key: $0, value: false) }
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(.index, archive.display.items.first?.key)
        XCTAssertFalse(archive.display.items.first?.value ?? true)
        XCTAssertFalse(archive.display.items.last?.value ?? true)
    }
}
