import Foundation
import Archivable

extension Cloud where Output == Archive {
    public func start() async {
        guard model.walks.isEmpty || model.walks.last!.duration > 0 else { return }
        add(walk: .init())
        await stream()
    }
    
    public func finish(steps: Int, metres: Int, tiles: Set<Tile>) async {
        guard model.walking != nil else { return }
        
        let walk = model.walks.removeLast()
        let duration = Calendar.global.duration(from: walk.timestamp)
        
        if duration > 0 {
            add(walk: .init(
                timestamp: walk.timestamp,
                duration: duration,
                steps: steps < UInt16.max ? .init(steps) : .max,
                metres: metres < UInt16.max ? .init(metres) : .max))
            
            model.tiles = model.tiles.union(tiles)
        }
        
        await stream()
    }
    
    public func cancel() async {
        guard model.walking != nil else { return }
        model.walks.removeLast()
        await stream()
    }
    
    func add(walk: Walk) {
        model.walks.append(walk)
    }
}
