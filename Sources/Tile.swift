import MapKit
import Archivable

private let tile = MKMapRect.world.width / pow(2, 20)

public struct Tile: Storable, Hashable {
    public let x: UInt32
    public let y: UInt32
    
    public var data: Data {
        Data()
            .adding(x)
            .adding(y)
    }
    
    public init(coordinate: CLLocationCoordinate2D) {
        let point = MKMapPoint(coordinate)
        let flatten = MKMapPoint(x: floor(point.x / tile), y: floor(point.y / tile))
        self.init(x: .init(flatten.x), y: .init(flatten.y))
    }
    
    public init(data: inout Data) {
        x = data.number()
        y = data.number()
    }
    
    init(x: Int, y: Int) {
        self.x = .init(x)
        self.y = .init(y)
    }
    
#if os(iOS) || os(macOS)
    var polygon: MKPolygon {
        { x, y in
                .init(points: [.init(x: x, y: y),
                               .init(x: x + tile, y: y),
                               .init(x: x + tile, y: y + tile),
                               .init(x: x, y: y + tile)],
                      count: 4)
        } (.init(x) * tile, .init(y) * tile)
    }
#endif
}
