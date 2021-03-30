import MapKit

extension CLLocationCoordinate2D {
    public var tile: Tile {
        {
            {
                .init(x: .init($0.x), y: .init($0.y))
            } (MKMapPoint(x: floor($0.x / Constants.map.tile), y: floor($0.y / Constants.map.tile)))
        } (MKMapPoint(self))
    }
}
