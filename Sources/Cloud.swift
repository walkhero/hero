import Foundation
import Archivable

extension Cloud where Output == Archive {
    public func start() async {
        guard model.walks.isEmpty || model.walks.last!.duration > 0 else { return }
        model.walks.append(.init())
        await stream()
    }
    
    public func finish(steps: Int, metres: Int, tiles: Set<Tile>) async {
        guard let walk = model.walks.popLast() else { return }
        
        let duration = Calendar.current.duration(from: walk.timestamp)
        
        if duration > 0 {
            
        }
        
        await stream()
    }
    
    func add(walk: Walk) {
        model.walks.append(walk)
    }
}
