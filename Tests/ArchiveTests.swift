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
        XCTAssertTrue(archive.squares.isEmpty)
    }
    
    func testWalks() async {
        archive.walks = [.init(timestamp: 100, offset: -5, duration: 50, steps: 35, metres: 24, calories: 123456)]
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(100, archive.walks.first?.timestamp)
        XCTAssertEqual(-5, archive.walks.first?.offset)
        XCTAssertEqual(50, archive.walks.first?.duration)
        XCTAssertEqual(35, archive.walks.first?.steps)
        XCTAssertEqual(24, archive.walks.first?.metres)
        XCTAssertEqual(123456, archive.walks.first?.calories)
    }
    
    func testTiles() async {
        archive.squares = [.init(x: 456, y: 9870)]
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(456, archive.squares.first?.x)
        XCTAssertEqual(9870, archive.squares.first?.y)
    }
    
    func testWalking() {
        archive.walks = [.init(timestamp: Date(timeIntervalSinceNow: -100).timestamp)]
        XCTAssertEqual(100, Int(Date.now.timeIntervalSince(archive.walking!)))
    }
}
