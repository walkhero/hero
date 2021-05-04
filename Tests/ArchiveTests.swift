import XCTest
import Combine
import Archivable
@testable import Hero

final class ArchiveTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .init(manifest: nil)
        subs = []
    }
    
    func testDate() {
        let date0 = Date(timeIntervalSince1970: 0)
        XCTAssertGreaterThanOrEqual(cloud.archive.value.data.prototype(Archive.self).date.timestamp, date0.timestamp)
        let date1 = Date(timeIntervalSince1970: 1)
        cloud.archive.value.date = date1
        XCTAssertGreaterThanOrEqual(cloud.archive.value.data.prototype(Archive.self).date.timestamp, date1.timestamp)
    }
    
    func testChallenges() {
        cloud.archive.value.challenges.insert(.steps)
        cloud.archive.value.challenges.insert(.map)
        XCTAssertEqual([.map, .steps], cloud.archive.value.data.prototype(Archive.self).challenges)
    }
    
    func testFinish() {
        let finish = Finish(duration: 34, streak: 12, steps: 43, metres: 543, area: 45)
        cloud.archive.value.finish = finish
        XCTAssertEqual(finish, cloud.archive.value.data.prototype(Archive.self).finish)
    }
    
    func testWalks() {
        let start = Date(timeIntervalSinceNow: -500)
        cloud.archive.value.walks = [.init(date: start, duration: 300, steps: 123, metres: 345)]
        XCTAssertEqual(300, Int(cloud.archive.value.data.prototype(Archive.self).walks.first!.duration))
        XCTAssertEqual(start.timestamp, cloud.archive.value.data.prototype(Archive.self).walks.first!.date.timestamp)
        XCTAssertEqual(123, cloud.archive.value.data.prototype(Archive.self).walks.first!.steps)
        XCTAssertEqual(345, cloud.archive.value.data.prototype(Archive.self).walks.first!.metres)
    }
    
    func testTiles() {
        cloud.archive.value.area = [.init(x: 2, y: 3), .init(x: 4, y: 4), .init(x: 1, y: 0)]
        XCTAssertEqual([.init(x: 4, y: 4), .init(x: 2, y: 3), .init(x: 1, y: 0)], cloud.archive.value.data.prototype(Archive.self).area)
    }
    
    func testStart() {
        let expect = expectation(description: "")
        let date = Date()
//        Repository.override!.sink {
//            XCTAssertEqual(1, $0.walks.count)
//            XCTAssertEqual(0, $0.walks.first?.duration)
//            XCTAssertGreaterThanOrEqual($0.walks.first!.date.timestamp, date.timestamp)
//            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
//            expect.fulfill()
//        }
//        .store(in: &subs)
        cloud.archive.value.start()
        waitForExpectations(timeout: 1)
    }
    
    func testEnd() {
        let expect = expectation(description: "")
        cloud.archive.value.walks = [.init(date: .init(timeIntervalSinceNow: -10))]
        let date = Date()
//        Repository.override!.sink {
//            XCTAssertEqual(1, $0.walks.count)
//            XCTAssertEqual(10, Int($0.walks.first!.duration))
//            XCTAssertEqual(Date(timeIntervalSinceNow: -10).timestamp, $0.walks.first!.date.timestamp)
//            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
//            expect.fulfill()
//        }
//        .store(in: &subs)
        cloud.archive.value.finish()
        waitForExpectations(timeout: 1)
    }

    func testEndWithData() {
        let expect = expectation(description: "")
        cloud.archive.value.walks = [.init(date: .init(timeIntervalSinceNow: -10))]
        cloud.archive.value.area = [.init(x: 7, y: 6), .init(x: 6, y: 7)]
        cloud.archive.value.discover = [.init(x: 7, y: 6), .init(x: 5, y: 0), .init(x: 2, y: 2), .init(x: 3, y: 2)]
//        Repository.override!.sink {
//
//            XCTAssertEqual(3, $0.walks.last?.steps)
//            XCTAssertEqual(4, $0.walks.last?.metres)
//            XCTAssertTrue($0.discover.isEmpty)
//            XCTAssertEqual([.init(x: 7, y: 6), .init(x: 6, y: 7), .init(x: 2, y: 2), .init(x: 3, y: 2), .init(x: 5, y: 0)], $0.area)
//            expect.fulfill()
//        }
//        .store(in: &subs)
        cloud.archive.value.finish(steps: 3, metres: 4)
        waitForExpectations(timeout: 1)
    }
    
    func testEndFinish() {
        let expect = expectation(description: "")
        cloud.archive.value.walks = [.init(date: Calendar.current.date(byAdding: .day, value: -1, to: .init())!),
                         .init(date: .init(timeIntervalSinceNow: -10))]
        cloud.archive.value.area = [.init(x: 7, y: 6), .init(x: 6, y: 7)]
        cloud.archive.value.discover = [.init(x: 7, y: 6), .init(x: 5, y: 0), .init(x: 2, y: 2), .init(x: 3, y: 2)]
//        Repository.override!.sink {
//            XCTAssertEqual(10, Int($0.finish.duration))
//            XCTAssertEqual(2, $0.finish.streak)
//            XCTAssertEqual(3, $0.finish.steps)
//            XCTAssertEqual(4, $0.finish.metres)
//            XCTAssertEqual(5, $0.finish.area)
//            XCTAssertTrue($0.finish.publish)
//            expect.fulfill()
//        }
//        .store(in: &subs)
        cloud.archive.value.finish(steps: 3, metres: 4)
        waitForExpectations(timeout: 1)
    }
    
    func testCancel() {
        let expect = expectation(description: "")
        cloud.archive.value.walks = [.init(date: .init(timeIntervalSinceNow: -10))]
        let date = Date()
        cloud.archive.value.discover(.init(x: 1, y: 2))
//        Repository.override!.sink {
//            XCTAssertTrue($0.walks.isEmpty)
//            XCTAssertTrue($0.tiles.isEmpty)
//            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
//            expect.fulfill()
//        }
//        .store(in: &subs)
        cloud.archive.value.cancel()
        waitForExpectations(timeout: 1)
    }
    
    func testStartChallenge() {
        let expect = expectation(description: "")
        let date = Date()
//        Repository.override!.sink {
//            XCTAssertTrue($0.enrolled(.map))
//            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
//            expect.fulfill()
//        }
//        .store(in: &subs)
        XCTAssertFalse(cloud.archive.value.enrolled(.map))
        cloud.archive.value.start(.map)
        waitForExpectations(timeout: 1)
    }
    
    func testStopChallenge() {
        let expect = expectation(description: "")
        let date = Date()
        cloud.archive.value.start(.map)
//        Repository.override!.sink {
//            XCTAssertFalse($0.enrolled(.map))
//            XCTAssertGreaterThanOrEqual($0.date.timestamp, date.timestamp)
//            expect.fulfill()
//        }
//        .store(in: &subs)
        XCTAssertTrue(cloud.archive.value.enrolled(.map))
        cloud.archive.value.stop(.map)
        waitForExpectations(timeout: 1)
    }
    
    func testWalking() throws {
        if case .none = cloud.archive.value.status {
            cloud.archive.value.start()
            if case let .walking(time) = cloud.archive.value.status {
                XCTAssertGreaterThan(time, 0)
                cloud.archive.value.finish()
                if case .none = cloud.archive.value.status {
                    
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
        XCTAssertNil(cloud.archive.value.last)
        cloud.archive.value.walks = [.init(date: .init(timeIntervalSinceNow: -500), duration: 300)]
        XCTAssertEqual(Date(timeIntervalSinceNow: -500).timestamp, cloud.archive.value.last?.start.timestamp)
        XCTAssertEqual(Date(timeIntervalSinceNow: -200).timestamp, cloud.archive.value.last?.end.timestamp)
    }
    
    func testList() {
        let date0 = Date(timeIntervalSinceNow: -1000)
        let date1 = Date(timeIntervalSinceNow: -800)
        let date2 = Date(timeIntervalSinceNow: -200)
        cloud.archive.value.walks = [
            .init(date: date0, duration: 100),
            .init(date: date1, duration: 500),
            .init(date: date2, duration: 50)]
        let list = cloud.archive.value.list
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
    
    func testDiscover() {
        cloud.archive.value.area = [.init(x: 7, y: 6), .init(x: 6, y: 7)]
//        Repository.override!.sink { _ in
//            XCTFail()
//        }
//        .store(in: &subs)
        cloud.archive.value.discover(.init(x: 5, y: 0))
    }
}
