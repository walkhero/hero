import XCTest
@testable import Hero

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .new
    }
    
    func testDate() {
        let date0 = Date(timeIntervalSince1970: 0)
        XCTAssertGreaterThanOrEqual(archive.data.prototype(Archive.self).date.timestamp, date0.timestamp)
        let date1 = Date(timeIntervalSince1970: 1)
        archive.date = date1
        XCTAssertGreaterThanOrEqual(archive.data.prototype(Archive.self).date.timestamp, date1.timestamp)
    }
    
    func testChallenges() {
        archive.challenges.insert(.steps)
        archive.challenges.insert(.map)
        XCTAssertEqual([.map, .steps], archive.data.prototype(Archive.self).challenges)
    }
    
    func testFinish() {
        let finish = Finish(duration: 34, streak: 12, steps: 43, metres: 543, area: 45)
        archive.finish = finish
        XCTAssertEqual(finish, archive.data.prototype(Archive.self).finish)
    }
    
    func testWalks() {
        let start = Date(timeIntervalSinceNow: -500)
        archive.walks = [.init(date: start, duration: 300, steps: 123, metres: 345)]
        XCTAssertEqual(300, Int(archive.data.prototype(Archive.self).walks.first!.duration))
        XCTAssertEqual(start.timestamp, archive.data.prototype(Archive.self).walks.first!.date.timestamp)
        XCTAssertEqual(123, archive.data.prototype(Archive.self).walks.first!.steps)
        XCTAssertEqual(345, archive.data.prototype(Archive.self).walks.first!.metres)
    }
    
    func testTiles() {
        archive.area = [.init(x: 2, y: 3), .init(x: 4, y: 4), .init(x: 1, y: 0)]
        XCTAssertEqual([.init(x: 4, y: 4), .init(x: 2, y: 3), .init(x: 1, y: 0)], archive.data.prototype(Archive.self).area)
    }
    
    func testWalking() throws {
        if case .none = archive.status {
            archive.start()
            if case let .walking(time) = archive.status {
                XCTAssertGreaterThan(time, 0)
                archive.finish()
                if case .none = archive.status {
                    
                } else {
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testLast() {
        XCTAssertNil(archive.last)
        archive.walks = [.init(date: .init(timeIntervalSinceNow: -500), duration: 300)]
        XCTAssertEqual(Date(timeIntervalSinceNow: -500).timestamp, archive.last?.start.timestamp)
        XCTAssertEqual(Date(timeIntervalSinceNow: -200).timestamp, archive.last?.end.timestamp)
    }
    
    func testList() {
        let date0 = Date(timeIntervalSinceNow: -1000)
        let date1 = Date(timeIntervalSinceNow: -800)
        let date2 = Date(timeIntervalSinceNow: -200)
        archive.walks = [
            .init(date: date0, duration: 100),
            .init(date: date1, duration: 500),
            .init(date: date2, duration: 50)]
        let list = archive.list
        XCTAssertEqual(date2.addingTimeInterval(50), list[0].date)
        XCTAssertEqual(50, list[0].duration)
        XCTAssertEqual(0.1, list[0].percent)
        XCTAssertEqual(date1.addingTimeInterval(500), list[1].date)
        XCTAssertEqual(500, list[1].duration)
        XCTAssertEqual(1, list[1].percent)
        XCTAssertEqual(date0.addingTimeInterval(100), list[2].date)
        XCTAssertEqual(100, list[2].duration)
        XCTAssertEqual(0.2, list[2].percent)
    }
}
