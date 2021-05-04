import XCTest
import Combine
import Archivable
@testable import Hero

final class FinishTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .init(manifest: nil)
        subs = []
    }
    
    func testNew() {
        XCTAssertFalse(cloud.archive.value.finish.publish)
    }
    
    func testFinish() {
        cloud.archive.value.walks = [.init(date: .init(timeIntervalSinceNow: -10))]
        cloud.archive.value.finish(steps: 34, metres: 56)
        XCTAssertTrue(cloud.archive.value.finish.publish)
    }
    
    func testPublish() {
        let expect = expectation(description: "")
        cloud.archive.value.walks = [.init(date: .init(timeIntervalSinceNow: -10))]
        cloud.archive.value.finish(steps: 1, metres: 1)
//        Repository.override!.sink {
//            XCTAssertEqual(.new, $0.finish)
//            expect.fulfill()
//        }
//        .store(in: &subs)
        cloud.archive.value.publish()
        waitForExpectations(timeout: 1)
    }
    
    func testPublishedPublish() {
//        Repository.override!.sink { _ in
//            XCTFail()
//        }
//        .store(in: &subs)
        cloud.archive.value.publish()
    }
    
    func testBestScoresMax() {
        let expect = expectation(description: "")
        cloud.archive.value.walks = [.init(date: Calendar.current.date(byAdding: .day, value: -1, to: .init())!),
                         .init(date: .init(timeIntervalSinceNow: -10))]
        cloud.archive.value.area = [.init(x: 7, y: 6), .init(x: 6, y: 7)]
        cloud.archive.value.discover = [.init(x: 7, y: 6), .init(x: 5, y: 0), .init(x: 2, y: 2), .init(x: 3, y: 2)]
        cloud.archive.value.finish(steps: 3, metres: 4)
        
        cloud.archive.value.walks.insert(.init(date: Calendar.current.date(byAdding: .day, value: -2, to: .init())!), at: 0)
        cloud.archive.value.walks.append(.init(date: .init(timeIntervalSinceNow: -20)))
        cloud.archive.value.discover = [.init(x: 33, y: 0)]
//        Repository.override!.sink {
//            XCTAssertEqual(20, Int($0.finish.duration))
//            XCTAssertEqual(3, $0.finish.streak)
//            XCTAssertEqual(6, $0.finish.steps)
//            XCTAssertEqual(5, $0.finish.metres)
//            XCTAssertEqual(6, $0.finish.area)
//            XCTAssertTrue($0.finish.publish)
//            expect.fulfill()
//        }
//        .store(in: &subs)
        cloud.archive.value.finish(steps: 6, metres: 5)
        waitForExpectations(timeout: 1)
    }
    
    func testBestScoresMin() {
        let expect = expectation(description: "")
        cloud.archive.value.walks = [.init(date: Calendar.current.date(byAdding: .day, value: -1, to: .init())!),
                         .init(date: .init(timeIntervalSinceNow: -10))]
        cloud.archive.value.area = [.init(x: 7, y: 6), .init(x: 6, y: 7)]
        cloud.archive.value.discover = [.init(x: 7, y: 6), .init(x: 5, y: 0), .init(x: 2, y: 2), .init(x: 3, y: 2)]
        cloud.archive.value.finish(steps: 3, metres: 4)
        
        cloud.archive.value.walks = [.init(date: .init(timeIntervalSinceNow: -2))]
        cloud.archive.value.area = []
//        Repository.override!.sink {
//            XCTAssertEqual(2, Int($0.finish.duration))
//            XCTAssertEqual(2, $0.finish.streak)
//            XCTAssertEqual(3, $0.finish.steps)
//            XCTAssertEqual(4, $0.finish.metres)
//            XCTAssertEqual(5, $0.finish.area)
//            XCTAssertTrue($0.finish.publish)
//            expect.fulfill()
//        }
//        .store(in: &subs)
        cloud.archive.value.finish(steps: 1, metres: 1)
        waitForExpectations(timeout: 1)
    }
}
