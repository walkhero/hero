import XCTest
@testable import Archivable
@testable import Hero

final class MigrationTests: XCTestCase {
    private var archive: Archive_v0!
    
    override func setUp() {
        archive = .init()
    }
    
    func testMigrate() async {
        archive.walks = [.init(timestamp: 100, offset: -5, duration: 50, steps: 35, metres: 24)]
        
        let migrated = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(100, migrated.walks.first?.timestamp)
        XCTAssertEqual(-5, migrated.walks.first?.offset)
        XCTAssertEqual(50, migrated.walks.first?.duration)
        XCTAssertEqual(35, migrated.walks.first?.steps)
        XCTAssertEqual(24, migrated.walks.first?.metres)
    }
}
