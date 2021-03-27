import XCTest
import MapKit
@testable import Hero

final class MapTests: XCTestCase {
    private let aberCastle = CLLocationCoordinate2D(latitude: 52.413244, longitude: -4.089675)
    private let deg1 = 110.574
    private let km11 = 0.1
    private let meters11 = 0.0001
    
    func testTilePer11m() {
        let start = MKMapPoint(aberCastle)
        let end = MKMapPoint(.init(latitude: aberCastle.latitude + meters11, longitude: aberCastle.longitude))
        let tileSize = MKMapRect.world.width / pow(2, Constants.map.zoom)
        let pointStart = MKMapPoint(x: floor(start.x / tileSize), y: floor(start.y / tileSize))
        let pointEnd = MKMapPoint(x: floor(end.x / tileSize), y: floor(end.y / tileSize))
        let total = (Int(abs(pointStart.x - pointEnd.x)) + 1) * (Int(abs(pointStart.y - pointEnd.y)) + 1)
        XCTAssertLessThan(total, 3)
    }
    
    func testTilesWithinUInt32() {
        let start = MKMapPoint(aberCastle)
        let end = MKMapPoint(.init(latitude: aberCastle.latitude + (km11 * 30), longitude: aberCastle.longitude + (km11 * 300)))
        let tileSize = MKMapRect.world.width / pow(2, Constants.map.zoom)
        let pointStart = MKMapPoint(x: floor(start.x / tileSize), y: floor(start.y / tileSize))
        let pointEnd = MKMapPoint(x: floor(end.x / tileSize), y: floor(end.y / tileSize))
        let total = (Int(abs(pointStart.x - pointEnd.x)) + 1) * (Int(abs(pointStart.y - pointEnd.y)) + 1)
        XCTAssertLessThan(total, 2_147_483_647)
    }
    
    func testTileIndexWithinUInt32() {
        XCTAssertLessThan(pow(4, Constants.map.zoom / 2), 2_147_483_647)
    }
}
