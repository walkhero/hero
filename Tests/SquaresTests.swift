import XCTest
import CoreLocation
@testable import Hero

final class SquaresTests: XCTestCase {
    private var squares: Squares!
    
    override func setUp() {
        squares = .init()
        try? FileManager.default.removeItem(at: squares.url)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: squares.url)
    }
    
    func testAdd() {
        squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        XCTAssertEqual(2, squares.items.count)
    }
    
    func testCache() {
        let expect = expectation(description: "")
        XCTAssertFalse(FileManager.default.fileExists(atPath: squares.url.path))
        squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            XCTAssertTrue(FileManager.default.fileExists(atPath: self.squares.url.path))
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testCacheDebounce() {
        squares.add(locations: [.init(latitude: 1, longitude: 2)])
        squares.add(locations: [.init(latitude: 2, longitude: 2)])
        squares.add(locations: [.init(latitude: 3, longitude: 2)])
        squares.add(locations: [.init(latitude: 4, longitude: 2)])
        squares.add(locations: [.init(latitude: 5, longitude: 2)])
        squares.add(locations: [.init(latitude: 6, longitude: 2)])
        squares.add(locations: [.init(latitude: 7, longitude: 2)])
        XCTAssertFalse(FileManager.default.fileExists(atPath: squares.url.path))
    }
    
    func testSaveOnlyUpdates() {
        squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        try? FileManager.default.removeItem(at: squares.url)
        
        squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        
        XCTAssertFalse(FileManager.default.fileExists(atPath: squares.url.path))
    }
    
    func testLoad() {
        let items = [Squares.Item(x: 530113, y: 521375), .init(x: 527200, y: 518461)]
        try? Data()
            .adding(size: UInt16.self, collection: items)
            .write(to: squares.url, options: .atomic)
        XCTAssertEqual(Squares().items, .init(items))
    }
    
    func testClear() {
        squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        squares.clear()
        XCTAssertTrue(squares.items.isEmpty)
        XCTAssertFalse(FileManager.default.fileExists(atPath: squares.url.path))
    }
}
