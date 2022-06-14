import XCTest
@testable import Hero

final class DisplayTests: XCTestCase {
    func testInitial() {
        XCTAssertEqual(Display.Key.allCases.count, Display().items.count)
    }
    
    func testParse() {
        var display = Display()
        display.items = Display.Key.allCases.reversed().map { .init(key: $0, value: false) }
        display = display.data.prototype()
        XCTAssertEqual(.index, display.items.first?.key)
        XCTAssertFalse(display.items.first?.value ?? true)
        XCTAssertFalse(display.items.last?.value ?? true)
    }
}
