import Foundation
import CoreLocation

public struct Squares: Equatable {
    public private(set) var items = Set<Item>()
    let url: URL
    
    public init() {
        url = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Squares.cache")
        
        print("init squares")
        guard
            FileManager.default.fileExists(atPath: url.path),
            var data = try? Data(contentsOf: url),
            !data.isEmpty
        else { return }
        
        items = .init(data.collection(size: UInt16.self))
        
        print("init squares \(items.count)")
    }
    
    public mutating func add(locations: [CLLocation]) {
        let update = items
            .union(locations
                    .map(\.coordinate)
                    .map(Item.init))
        
        guard update != items else { return }
        items = update
        
        try! Data()
            .adding(size: UInt16.self, collection: items)
            .write(to: url, options: .atomic)
        
        print("save \(items.count)")
    }
    
    public mutating func clear() {
        items = []
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        try? FileManager.default.removeItem(at: url)
        
        print("delete squares")
    }
}
