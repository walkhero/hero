import Foundation
import Archivable

extension Cloud where Output == Archive {
    public func start() async {
        guard model.walking == 0 else { return }
        model.walking = Date.now.timestamp
        await stream()
    }
    
    public func finish(steps: Int,
                       metres: Int,
                       calories: Int,
                       squares: Set<Squares.Item>) async -> Summary? {
        
        guard model.walking != 0 else { return nil }
        
        let started = model.walking
        let duration = Calendar.global.duration(from: started)
        let steps = steps < UInt16.max ? UInt16(steps) : .max
        let metres = metres < UInt16.max ? UInt16(metres) : .max
        let calories = calories < UInt32.max ? UInt32(calories) : .max
        let tiles = model.tiles
        let previous = Leaf(squares: tiles.count)
        let current = Leaf(squares: tiles.union(squares).count)
        let count = squares.subtracting(tiles).count
        let walks = model.walks
        var total = walks.count
        
        model.walking = 0
        
        if duration > 0 {
            model.walks = walks + .init(
                timestamp: started,
                duration: duration,
                steps: steps,
                metres: metres,
                calories: calories)
            
            model.tiles = tiles.union(squares)
            total += 1
        }
        
        Task
            .detached { [weak self] in
                await self?.stream()
            }
        
        return .init(
            leaf: previous.name == current.name ? nil : current,
            duration: .init(duration),
            walks: total,
            steps: .init(steps),
            metres: .init(metres),
            calories: .init(calories),
            squares: count,
            streak: model.walks.map(\.date).calendar.streak.current)
    }
    
    public func cancel() async {
        guard model.walking != 0 else { return }
        model.walking = 0
        await stream()
    }
}
