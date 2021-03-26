import XCTest
@testable import Hero

final class HeroTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Hero().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
