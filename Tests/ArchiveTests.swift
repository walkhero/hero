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
    }
    
    func testWalks() async {
        archive.walks = [.init(timestamp: 100, offset: -5, duration: 50, steps: 35, metres: 24)]
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(100, archive.walks.first?.timestamp)
        XCTAssertEqual(-5, archive.walks.first?.offset)
        XCTAssertEqual(50, archive.walks.first?.duration)
        XCTAssertEqual(35, archive.walks.first?.steps)
        XCTAssertEqual(24, archive.walks.first?.metres)
    }
    
    func testTiles() async {
        archive.tiles = [.init(x: 456, y: 9870)]
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(456, archive.tiles.first?.x)
        XCTAssertEqual(9870, archive.tiles.first?.y)
    }
}
