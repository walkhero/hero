import XCTest
import CoreLocation
@testable import Hero

final class SquaresTests: XCTestCase {
    private var squares: Squares!
    
    override func setUp() {
        squares = .init()
        try? FileManager.default.removeItem(at: Squares.url)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: Squares.url)
    }
    
    func testAdd() async {
        _ = await squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        let items = await squares.items
        XCTAssertEqual(2, items.count)
    }
    
    func testCache() {
        let expect = expectation(description: "")
        XCTAssertFalse(FileManager.default.fileExists(atPath: Squares.url.path))
        
        Task {
            _ = await squares.add(locations: [.init(latitude: 1, longitude: 2),
                                    .init(latitude: 2, longitude: 1)])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            XCTAssertTrue(FileManager.default.fileExists(atPath: Squares.url.path))
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testCacheDebounce() async {
        _ = await squares.add(locations: [.init(latitude: 1, longitude: 2)])
        _ = await squares.add(locations: [.init(latitude: 2, longitude: 2)])
        _ = await squares.add(locations: [.init(latitude: 3, longitude: 2)])
        _ = await squares.add(locations: [.init(latitude: 4, longitude: 2)])
        _ = await squares.add(locations: [.init(latitude: 5, longitude: 2)])
        _ = await squares.add(locations: [.init(latitude: 6, longitude: 2)])
        _ = await squares.add(locations: [.init(latitude: 7, longitude: 2)])
        XCTAssertFalse(FileManager.default.fileExists(atPath: Squares.url.path))
    }
    
    func testSaveOnlyUpdates() async {
        _ = await squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        try? FileManager.default.removeItem(at: Squares.url)
        
        _ = await squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        
        XCTAssertFalse(FileManager.default.fileExists(atPath: Squares.url.path))
    }
    
    func testLoad() async {
        let items = [Squares.Item(x: 530113, y: 521375), .init(x: 527200, y: 518461)]
        try? Data()
            .adding(size: UInt16.self, collection: items)
            .write(to: Squares.url, options: .atomic)
        
        let result = await Squares().items
        
        XCTAssertEqual(result, .init(items))
    }
    
    func testClear() async {
        _ = await squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        await squares.clear()
        let task = await squares.task!
        let items = await squares.items
        
        XCTAssertTrue(task.isCancelled)
        XCTAssertTrue(items.isEmpty)
        XCTAssertFalse(FileManager.default.fileExists(atPath: Squares.url.path))
    }
}
