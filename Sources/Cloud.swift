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
    
    public func migrate(directory: URL) async {
        let file = directory.appendingPathComponent("WalkHero.archive")
        
        guard
            FileManager.default.fileExists(atPath: file.path),
            var data = try? Data(contentsOf: file),
            !data.isEmpty
        else { return }
        
        let offset = Calendar.global.offset
        
        _ = data.date()
        
        _ = (0 ..< .init(data.number() as UInt8))
            .map { _ in
                data.number() as UInt8
            }
        
        model.walks.append(contentsOf:
                            (0 ..< .init(data.number() as UInt32))
                            .map { _ in
                            .init(timestamp: data.number(),
                                  offset: offset,
                                  duration: data.number(),
                                  steps: data.number(),
                                  metres: data.number())
        })
        
        model.tiles = model.tiles.union(Set(data.collection(size: UInt32.self) as [Tile]))
        
        await stream()
        try? FileManager.default.removeItem(at: file)
    }
    
    func add(walk: Walk) {
        model.walks.append(walk)
    }
}
