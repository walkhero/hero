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
            
            model.tiles = .init(.init(tiles) + .init(model.tiles))
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
            let data = try? Data(contentsOf: file),
            !data.isEmpty
            
        else { return }
        
        await stream()
        try? FileManager.default.removeItem(at: file)
        
        /*
         date = data.date()
         challenges = .init((0 ..< .init(data.removeFirst())).map { _ in
             .init(data: &data)
         })
         walks = (0 ..< .init(data.uInt32())).map { _ in
             .init(data: &data)
         }
         area = .init((0 ..< .init(data.uInt32())).map { _ in
             .init(data: &data)
         })
         finish = .init(data: &data)
         */
    }
    
    func add(walk: Walk) {
        model.walks.append(walk)
    }
}
