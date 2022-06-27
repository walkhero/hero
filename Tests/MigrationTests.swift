import XCTest
@testable import Archivable
@testable import Hero

final class MigrationTests: XCTestCase {
    private var archive: Archive_v0!
    
    override func setUp() {
        archive = .init()
    }
    
    func testMigrateWalking() async {
        archive.walks = [.init(timestamp: 100, offset: -5, duration: 50, steps: 35, metres: 24),
                         .init(timestamp: 10, offset: -3, duration: 40, steps: 30, metres: 26),
                         .init(timestamp: 7)]
        
        let migrated = await Archive.init(version: Archive_v0.version, timestamp: archive.timestamp, data: archive.data)
        XCTAssertEqual(2, migrated.walks.count)
        XCTAssertEqual(100, migrated.walks.first?.timestamp)
        XCTAssertEqual(-5, migrated.walks.first?.offset)
        XCTAssertEqual(50, migrated.walks.first?.duration)
        XCTAssertEqual(35, migrated.walks.first?.steps)
        XCTAssertEqual(24, migrated.walks.first?.metres)
        XCTAssertEqual(0, migrated.walks.first?.calories)
        XCTAssertEqual(10, migrated.walks.last?.timestamp)
        XCTAssertEqual(-3, migrated.walks.last?.offset)
        XCTAssertEqual(40, migrated.walks.last?.duration)
        XCTAssertEqual(30, migrated.walks.last?.steps)
        XCTAssertEqual(26, migrated.walks.last?.metres)
        XCTAssertEqual(0, migrated.walks.last?.calories)
        XCTAssertEqual(7, migrated.walking)
    }
    
    func testMigrateNotWalking() async {
        archive.walks = [.init(timestamp: 100, offset: -5, duration: 50, steps: 35, metres: 24),
                         .init(timestamp: 10, offset: -3, duration: 40, steps: 30, metres: 26)]
        
        let migrated = await Archive.init(version: Archive_v0.version, timestamp: archive.timestamp, data: archive.data)
        XCTAssertEqual(2, migrated.walks.count)
        XCTAssertEqual(100, migrated.walks.first?.timestamp)
        XCTAssertEqual(10, migrated.walks.last?.timestamp)
        XCTAssertEqual(0, migrated.walking)
    }
}
