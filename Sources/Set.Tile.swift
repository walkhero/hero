#if os(iOS) || os(macOS)

import MapKit

extension Set where Element == Tile {
    private static let world = [MKMapPoint(),
                                .init(x: MKMapSize.world.width, y: 0),
                                .init(x: MKMapSize.world.width, y: MKMapSize.world.height),
                                .init(x: 0, y: MKMapSize.world.height)]
    
    public var overlay: MKPolygon {
        .init(points: Self.world, count: 4, interiorPolygons: map(\.polygon))
    }
}

#endif
