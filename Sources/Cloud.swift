import Foundation
import Archivable

extension Cloud where Output == Archive {
    public func start() async {
        guard model.walks.isEmpty || model.walks.last!.duration > 0 else { return }
        add(walk: .init())
        await stream()
    }
    
    public func finish(steps: Int, metres: Int, tiles: Set<Squares.Item>) async -> Summary? {
        guard model.walking != nil else { return nil }
        
        let walk = model.walks.removeLast()
        let duration = Calendar.global.duration(from: walk.timestamp)
        let steps = steps < UInt16.max ? UInt16(steps) : .max
        let metres = metres < UInt16.max ? UInt16(metres) : .max
        let squares = tiles.subtracting(model.tiles).count
        
        if duration > 0 {
            add(walk: .init(
                timestamp: walk.timestamp,
                duration: duration,
                steps: steps,
                metres: metres))
            
            model.tiles = model.tiles.union(tiles)
        }
        
        await stream()
        
        return .init(started: .init(timestamp: walk.timestamp),
                     steps: .init(steps),
                     metres: .init(metres),
                     squares: squares,
                     streak: model.calendar.streak.current)
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
