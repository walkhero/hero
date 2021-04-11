import XCTest
@testable import Hero

final class MetresTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .new
        Repository.override = .init()
    }
    
    func testEmpty() {
        XCTAssertEqual(0, archive.maxMetres)
        XCTAssertEqual(.zero, archive.metres)
    }
    
    func testMax() {
        archive.walks.append(.init(date: .init(), metres: 1))
        XCTAssertEqual(1, archive.maxMetres)
        archive.walks.append(.init(date: .init(), metres: 5))
        XCTAssertEqual(5, archive.maxMetres)
        archive.walks.append(.init(date: .init(), metres: 3))
        XCTAssertEqual(5, archive.maxMetres)
    }
    
    func testStepsMax20() {
        archive.walks = [
            .init(date: .init(), duration: 1, metres: 3),
            .init(date: .init(), duration: 1, metres: 4),
            .init(date: .init(), duration: 1, metres: 5),
            .init(date: .init(), duration: 1, metres: 2),
            .init(date: .init(), duration: 1, metres: 6),
            .init(date: .init(), duration: 1, metres: 7),
            .init(date: .init(), duration: 1, metres: 8),
            .init(date: .init(), duration: 1, metres: 4),
            .init(date: .init(), duration: 1, metres: 10),
            .init(date: .init(), duration: 1, metres: 0),
            .init(date: .init(), duration: 1, metres: 1),
            .init(date: .init(), duration: 1, metres: 5),
            .init(date: .init(), duration: 1, metres: 3),
            .init(date: .init(), duration: 1, metres: 2),
            .init(date: .init(), duration: 1, metres: 6),
            .init(date: .init(), duration: 1, metres: 7),
            .init(date: .init(), duration: 1, metres: 8),
            .init(date: .init(), duration: 1, metres: 4),
            .init(date: .init(), duration: 1, metres: 10),
            .init(date: .init(), duration: 1, metres: 0),
            .init(date: .init(), duration: 1, metres: 1),
            .init(date: .init(), duration: 1, metres: 5),
            .init(date: .init(), duration: 1, metres: 3)]
        XCTAssertEqual([
                        0.2,
                        0.6,
                        0.7,
                        0.8,
                        0.4,
                        1,
                        0,
                        0.1,
                        0.5,
                        0.3,
                        0.2,
                        0.6,
                        0.7,
                        0.8,
                        0.4,
                        1,
                        0,
                        0.1,
                        0.5,
                        0.3], archive.metres.values)
        XCTAssertEqual(10, archive.metres.max)
    }
    
    func testStepsZero() {
        archive.walks = [
            .init(date: .init(), duration: 1, metres: 0),
            .init(date: .init(), duration: 1, metres: 0),
            .init(date: .init(), duration: 1, metres: 0)]
        XCTAssertEqual([
                        0,
                        0,
                        0], archive.metres.values)
        XCTAssertEqual(0, archive.metres.max)
    }
}
