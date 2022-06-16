import XCTest
@testable import Hero

final class LeafTests: XCTestCase {
    func testGreen() {
        let leaf = Leaf(squares: 0)
        XCTAssertEqual(.green, leaf.name)
        XCTAssertEqual(0, leaf.squares)
        XCTAssertEqual(128, leaf.next)
    }
    
    func testEarth() {
        let leaf = Leaf(squares: 128)
        XCTAssertEqual(.earth, leaf.name)
        XCTAssertEqual(128, leaf.squares)
        XCTAssertEqual(Int(pow(2, 8) as Double), leaf.next)
    }
    
    func testAir() {
        let leaf = Leaf(squares: 256)
        XCTAssertEqual(.air, leaf.name)
        XCTAssertEqual(256, leaf.squares)
        XCTAssertEqual(Int(pow(2, 9) as Double), leaf.next)
    }
    
    func testWater() {
        var leaf = Leaf(squares: 512)
        XCTAssertEqual(.water, leaf.name)
        XCTAssertEqual(512, leaf.squares)
        XCTAssertEqual(Int(pow(2, 10) as Double), leaf.next)
        
        leaf = Leaf(squares: 514)
        XCTAssertEqual(.water, leaf.name)
        XCTAssertEqual(514, leaf.squares)
        XCTAssertEqual(Int(pow(2, 10) as Double), leaf.next)
    }
    
    func testTin() {
        let leaf = Leaf(squares: 20_175)
        XCTAssertEqual(.tin, leaf.name)
        XCTAssertEqual(20_175, leaf.squares)
        XCTAssertEqual(Int(pow(2, 15) as Double), leaf.next)
    }
    
    func testCopper() {
        let leaf = Leaf(squares: 42_165)
        XCTAssertEqual(.copper, leaf.name)
        XCTAssertEqual(42_165, leaf.squares)
        XCTAssertEqual(Int(pow(2, 16) as Double), leaf.next)
    }
    
    func testLong() {
        let leaf = Leaf(squares: 1_223_456)
        XCTAssertEqual(.palladium, leaf.name)
        XCTAssertEqual(1_223_456, leaf.squares)
        XCTAssertEqual(Int(pow(2, 21) as Double), leaf.next)
    }
}
