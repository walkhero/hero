import Foundation
import Archivable

extension Cloud where Output == Archive {
    public func start() async {
        guard model.walking == 0 else { return }
        model.walking = Date.now.timestamp
        await stream()
    }
    
    public func finish(steps: Int, metres: Int, calories: Int, squares: Set<Squares.Item>) async -> Summary? {
        guard model.walking != 0 else { return nil }
        
        let started = model.walking
        let duration = Calendar.global.duration(from: started)
        let steps = steps < UInt16.max ? UInt16(steps) : .max
        let metres = metres < UInt16.max ? UInt16(metres) : .max
        let calories = calories < UInt32.max ? UInt32(calories) : .max
        let tiles = model.tiles
        let count = squares.subtracting(tiles).count
        
        model.walking = 0
        
        if duration > 0 {
            model.walks += .init(
                timestamp: started,
                duration: duration,
                steps: steps,
                metres: metres,
                calories: calories)
            
            model.tiles = tiles.union(squares)
        }
        
        await stream()
        
        return .init(started: .init(timestamp: started),
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
