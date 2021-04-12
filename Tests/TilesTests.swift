import XCTest
@testable import Hero

final class TilesTests: XCTestCase {
    func testOverlay() {
        let overlay = Set([Tile(x: 0, y: 0), .init(x: 1, y: 1)]).overlay.interiorPolygons?.sorted { $0.boundingMapRect.minX < $1.boundingMapRect.minX }
        XCTAssertEqual(2, overlay?.count)
        
        XCTAssertEqual(0, overlay?.first?.boundingMapRect.minX)
        XCTAssertEqual(0, overlay?.first?.boundingMapRect.minY)
        XCTAssertEqual(Constants.map.tile, overlay?.first?.boundingMapRect.maxX)
        XCTAssertEqual(Constants.map.tile, overlay?.first?.boundingMapRect.maxY)
        
        XCTAssertEqual(Constants.map.tile, overlay?.last?.boundingMapRect.minX)
        XCTAssertEqual(Constants.map.tile, overlay?.last?.boundingMapRect.minY)
        XCTAssertEqual(Constants.map.tile * 2, overlay?.last?.boundingMapRect.maxX)
        XCTAssertEqual(Constants.map.tile * 2, overlay?.last?.boundingMapRect.maxY)
    }
}
