import XCTest
@testable import Hero

final class MigrationTests: XCTestCase {
    override func setUp() {
        Repository.override = .init()
    }
    
    func testMigrateDiscover() {
        XCTAssertTrue(Archive.new.data.dropLast(2).mutating(transform: Archive.init(data:)).discover.isEmpty)
    }
}
