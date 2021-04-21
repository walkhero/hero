import XCTest
@testable import Hero

final class MigrationTests: XCTestCase {
    func testFinish() {
        var archive = Archive()
        archive.challenges.insert(.map)
        let data = archive.data.dropLast(13)
        XCTAssertTrue(data.mutating(transform: Archive.init(data:)).enrolled(.map))
    }
}
