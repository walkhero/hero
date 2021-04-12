import XCTest
import Combine
@testable import Hero

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    private var subs = Set<AnyCancellable>()
    
    override func setUp() {
        archive = .new
        Repository.override = .init()
    }
    
    func testDate() {
        let date0 = Date(timeIntervalSince1970: 0)
        archive = .new
        XCTAssertGreaterThanOrEqual(archive.data.mutating(transform: Archive.init(data:)).date.timestamp, date0.timestamp)
        let date1 = Date(timeIntervalSince1970: 1)
        archive.date = date1
        XCTAssertGreaterThanOrEqual(archive.data.mutating(transform: Archive.init(data:)).date.timestamp, date1.timestamp)
    }
    
    func testChallenges() {
        archive.challenges.insert(.steps)
        archive.challenges.insert(.map)
        XCTAssertEqual([.map, .steps], archive.data.mutating(transform: Archive.init(data:)).challenges)
    }
    
    func testWalks() {
        let start = Date(timeIntervalSinceNow: -500)
        archive.walks = [.init(date: start, duration: 300, steps: 123, metres: 345)]
        XCTAssertEqual(300, Int(archive.data.mutating(transform: Archive.init(data:)).walks.first!.duration))
        XCTAssertEqual(start.timestamp, archive.data.mutating(transform: Archive.init(data:)).walks.first!.date.timestamp)
        XCTAssertEqual(123, archive.data.mutating(transform: Archive.init(data:)).walks.first!.steps)
        XCTAssertEqual(345, archive.data.mutating(transform: Archive.init(data:)).walks.first!.metres)
    }
    
    func testTiles() {
        archive.area = [.init(x: 2, y: 3), .init(x: 4, y: 4), .init(x: 1, y: 0)]
        XCTAssertEqual([.init(x: 4, y: 4), .init(x: 2, y: 3), .init(x: 1, y: 0)], archive.data.mutating(transform: Archive.init(data:)).area)
        
        archive.discover = [.init(x: 2, y: 3), .init(x: 4, y: 4), .init(x: 1, y: 0)]
        XCTAssertEqual([.init(x: 4, y: 4), .init(x: 2, y: 3), .init(x: 1, y: 0)], archive.data.mutating(transform: Archive.init(data:)).discover)
    }
    
    func testStart() {
        let expect = expectation(description: "")
        let date = Date()
        Repository.override!.sink {
            XCTAssertEqual(1, $0.walks.count)
            XCTAssertEqual(0, $0.walks.first?.duration)
            XCTAssertGreaterThanOrEqual($0.walks.first!.date.timestamp, date.timestamp)
            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
            expect.fulfill()
        }
        .store(in: &subs)
        archive.start()
        waitForExpectations(timeout: 1)
    }
    
    func testEnd() {
        let expect = expectation(description: "")
        archive.walks = [.init(date: .init(timeIntervalSinceNow: -10))]
        let date = Date()
        Repository.override!.sink {
            XCTAssertEqual(1, $0.walks.count)
            XCTAssertEqual(10, Int($0.walks.first!.duration))
            XCTAssertEqual(Date(timeIntervalSinceNow: -10).timestamp, $0.walks.first!.date.timestamp)
            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
            expect.fulfill()
        }
        .store(in: &subs)
        archive.end()
        waitForExpectations(timeout: 1)
    }

    func testEndWithData() {
        let expect = expectation(description: "")
        archive.walks = [.init(date: .init(timeIntervalSinceNow: -10))]
        archive.area = [.init(x: 7, y: 6), .init(x: 6, y: 7)]
        archive.discover = [.init(x: 7, y: 6), .init(x: 5, y: 0), .init(x: 2, y: 2), .init(x: 3, y: 2)]
        Repository.override!.sink {
            XCTAssertEqual(3, $0.walks.last?.steps)
            XCTAssertEqual(4, $0.walks.last?.metres)
            XCTAssertTrue($0.discover.isEmpty)
            XCTAssertEqual([.init(x: 7, y: 6), .init(x: 6, y: 7), .init(x: 2, y: 2), .init(x: 3, y: 2), .init(x: 5, y: 0)], $0.area)
            expect.fulfill()
        }
        .store(in: &subs)
        archive.end(steps: 3, metres: 4)
        waitForExpectations(timeout: 1)
    }
    
    func testCancel() {
        let expect = expectation(description: "")
        archive.walks = [.init(date: .init(timeIntervalSinceNow: -10))]
        let date = Date()
        archive.discover(.init(x: 1, y: 2))
        Repository.override!.sink {
            XCTAssertTrue($0.walks.isEmpty)
            XCTAssertTrue($0.tiles.isEmpty)
            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
            expect.fulfill()
        }
        .store(in: &subs)
        archive.cancel()
        waitForExpectations(timeout: 1)
    }
    
    func testStartChallenge() {
        let expect = expectation(description: "")
        let date = Date()
        Repository.override!.sink {
            XCTAssertTrue($0.enrolled(.map))
            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
            expect.fulfill()
        }
        .store(in: &subs)
        XCTAssertFalse(archive.enrolled(.map))
        archive.start(.map)
        waitForExpectations(timeout: 1)
    }
    
    func testStopChallenge() {
        let expect = expectation(description: "")
        let date = Date()
        archive.start(.map)
        Repository.override!.sink {
            XCTAssertFalse($0.enrolled(.map))
            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
            expect.fulfill()
        }
        .store(in: &subs)
        XCTAssertTrue(archive.enrolled(.map))
        archive.stop(.map)
        waitForExpectations(timeout: 1)
    }
    
    func testWalking() throws {
        if case .none = archive.status {
            archive.start()
            if case let .walking(time) = archive.status {
                XCTAssertGreaterThan(time, 0)
                archive.end()
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
        XCTAssertEqual(date2, list[0].date)
        XCTAssertEqual(50, list[0].duration)
        XCTAssertEqual(0.1, list[0].percent)
        XCTAssertEqual(date1, list[1].date)
        XCTAssertEqual(500, list[1].duration)
        XCTAssertEqual(1, list[1].percent)
        XCTAssertEqual(date0, list[2].date)
        XCTAssertEqual(100, list[2].duration)
        XCTAssertEqual(0.2, list[2].percent)
    }
    
    func testDiscover() {
        let expect = expectation(description: "")
        archive.area = [.init(x: 7, y: 6), .init(x: 6, y: 7)]
        Repository.override!.sink {
            XCTAssertEqual([.init(x: 7, y: 6), .init(x: 6, y: 7), .init(x: 5, y: 0)], $0.tiles)
            expect.fulfill()
        }
        .store(in: &subs)
        archive.discover(.init(x: 5, y: 0))
        waitForExpectations(timeout: 1)
    }
    
    func testNotSaveIfExisting() {
        archive.area = [.init(x: 5, y: 0)]
        archive.discover = [.init(x: 3, y: 1)]
        Repository.override!.sink { _ in
            XCTFail()
        }
        .store(in: &subs)
        archive.discover(.init(x: 5, y: 0))
        archive.discover(.init(x: 3, y: 1))
    }
}
