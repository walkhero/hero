import Foundation

extension Set where Element == Tile {
    public func with(zoom: Int) -> Self {
        .init(map {
            .init(x: .init(.init($0.x) * Constants.map.tile / Constants.map.with(zoom: zoom)),
                  y: .init(.init($0.y) * Constants.map.tile / Constants.map.with(zoom: zoom)))
        })
    }
}
