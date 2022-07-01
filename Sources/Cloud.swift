import Foundation
import Archivable

extension Cloud where Output == Archive {
    public func start() async {
        guard model.walking == 0 else { return }
        model.walking = Date.now.timestamp
        await stream()
    }
    
    public func finish(
        duration: UInt16,
        steps: Int,
        metres: Int,
        calories: Int,
        squares: Set<Squares.Item>) async {
            let started = model.walking
            guard started != 0 else { return }
            
            model.walking = 0
            
            if duration > 0 {
                let steps = steps < UInt16.max ? UInt16(steps) : .max
                let metres = metres < UInt16.max ? UInt16(metres) : .max
                let calories = calories < UInt32.max ? UInt32(calories) : .max
                let tiles = model.tiles
                let walks = model.walks
                
                model.walks = walks + .init(
                    timestamp: started,
                    duration: duration,
                    steps: steps,
                    metres: metres,
                    calories: calories)
                
                model.tiles = tiles.union(squares)
            }
            
            await stream()
        }
    
    public func cancel() async {
        guard model.walking != 0 else { return }
        model.walking = 0
        await stream()
    }
}
