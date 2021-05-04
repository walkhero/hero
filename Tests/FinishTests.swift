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
        let expect = expectation(description: "")
        cloud.archive.value.walks = [.init(date: .init(timeIntervalSinceNow: -10))]
        
        cloud
            .archive
            .dropFirst()
            .sink {
                XCTAssertTrue($0.finish.publish)
                expect.fulfill()
            }
            .store(in: &subs)
        
        cloud.finish(steps: 34, metres: 56)
        waitForExpectations(timeout: 1)
    }
    
    func testPublish() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        cloud.archive.value.walks = [.init(date: .init(timeIntervalSinceNow: -10))]
        
        cloud
            .archive
            .dropFirst()
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &subs)
        
        cloud.finish(steps: 1, metres: 1)
        cloud.publish()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(.new, self.cloud.archive.value.finish)
        }
    }
    
    func testPublishedPublish() {
        cloud
            .archive
            .dropFirst()
            .sink { _ in
                XCTFail()
            }
            .store(in: &subs)
        cloud.publish()
    }
    
    func testBestScoresMax() {
        let expect = expectation(description: "")
        cloud.archive.value.walks = [.init(date: Calendar.current.date(byAdding: .day, value: -1, to: .init())!),
                         .init(date: .init(timeIntervalSinceNow: -10))]
        cloud.archive.value.area = [.init(x: 7, y: 6), .init(x: 6, y: 7)]
        cloud.archive.value.discover = [.init(x: 7, y: 6), .init(x: 5, y: 0), .init(x: 2, y: 2), .init(x: 3, y: 2)]
        
        cloud
            .archive
            .dropFirst()
            .first()
            .sink { _ in
                self.cloud.archive.value.walks.insert(.init(date: Calendar.current.date(byAdding: .day, value: -2, to: .init())!), at: 0)
                self.cloud.archive.value.walks.append(.init(date: .init(timeIntervalSinceNow: -20)))
                self.cloud.archive.value.discover = [.init(x: 33, y: 0)]
                
                self.cloud
                    .archive
                    .dropFirst()
                    .sink {
                        XCTAssertEqual(20, Int($0.finish.duration))
                        XCTAssertEqual(3, $0.finish.streak)
                        XCTAssertEqual(6, $0.finish.steps)
                        XCTAssertEqual(5, $0.finish.metres)
                        XCTAssertEqual(6, $0.finish.area)
                        XCTAssertTrue($0.finish.publish)
                        expect.fulfill()
                    }
                    .store(in: &self.subs)
                
                self.cloud.finish(steps: 6, metres: 5)
            }
            .store(in: &subs)
        
        cloud.finish(steps: 3, metres: 4)
        waitForExpectations(timeout: 1)
    }
    
    func testBestScoresMin() {
        let expect = expectation(description: "")
        cloud.archive.value.walks = [.init(date: Calendar.current.date(byAdding: .day, value: -1, to: .init())!),
                         .init(date: .init(timeIntervalSinceNow: -10))]
        cloud.archive.value.area = [.init(x: 7, y: 6), .init(x: 6, y: 7)]
        cloud.archive.value.discover = [.init(x: 7, y: 6), .init(x: 5, y: 0), .init(x: 2, y: 2), .init(x: 3, y: 2)]
        
        cloud
            .archive
            .dropFirst()
            .first()
            .sink { _ in
                self.cloud.archive.value.walks = [.init(date: .init(timeIntervalSinceNow: -2))]
                self.cloud.archive.value.area = []
                
                self.cloud
                    .archive
                    .dropFirst()
                    .sink {
                        XCTAssertEqual(2, Int($0.finish.duration))
                        XCTAssertEqual(2, $0.finish.streak)
                        XCTAssertEqual(3, $0.finish.steps)
                        XCTAssertEqual(4, $0.finish.metres)
                        XCTAssertEqual(5, $0.finish.area)
                        XCTAssertTrue($0.finish.publish)
                        expect.fulfill()
                    }
                    .store(in: &self.subs)
                self.cloud.finish(steps: 1, metres: 1)
            }
            .store(in: &subs)
        
        cloud.finish(steps: 3, metres: 4)
        waitForExpectations(timeout: 1)
    }
}
