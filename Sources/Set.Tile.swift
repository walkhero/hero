#if os(iOS) || os(macOS)

import MapKit

private let world = [MKMapPoint(),
                     .init(x: MKMapSize.world.width, y: 0),
                     .init(x: MKMapSize.world.width, y: MKMapSize.world.height),
                     .init(x: 0, y: MKMapSize.world.height)]

extension Set where Element == Squares.Item {
    public var overlay: MKPolygon {
        .init(points: world, count: 4, interiorPolygons: map(\.polygon))
    }
}

#endif
