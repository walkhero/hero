import XCTest
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
        XCTAssertFalse(FileManager.default.fileExists(atPath: squares.url.path))
        squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        XCTAssertTrue(FileManager.default.fileExists(atPath: squares.url.path))
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
        squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        XCTAssertEqual(Squares().items, squares.items)
    }
    
    func testClear() {
        squares.add(locations: [.init(latitude: 1, longitude: 2),
                                .init(latitude: 2, longitude: 1)])
        squares.clear()
        XCTAssertTrue(squares.items.isEmpty)
        XCTAssertFalse(FileManager.default.fileExists(atPath: squares.url.path))
    }
}
