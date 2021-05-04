import XCTest
import Combine
import Archivable
@testable import Hero

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .init(manifest: nil)
        subs = []
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
    
    func testDiscover() {
        cloud.archive.value.area = [.init(x: 7, y: 6), .init(x: 6, y: 7)]
//        Repository.override!.sink { _ in
            XCTFail()
//        }
//        .store(in: &subs)
        cloud.archive.value.discover(.init(x: 5, y: 0))
    }
}
