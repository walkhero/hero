import Foundation
import CoreLocation

public struct Squares: Equatable {
    public private(set) var items = Set<Item>()
    let url: URL
    private var task: Task<Void, Never>?
    
    public init() {
        url = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Squares.cache")
        
        if FileManager.default.fileExists(atPath: url.path),
           var data = try? Data(contentsOf: url),
           !data.isEmpty {
            items = .init(data.collection(size: UInt16.self))
        }
    }
    
    public mutating func add(locations: [CLLocation]) {
        let update = items
            .union(locations
                    .map(\.coordinate)
                    .map(Item.init))
        
        if update != items {
            items = update
            
            task?.cancel()
            task = Task { [url] in
                do {
                    try await Task.sleep(nanoseconds: 500_000_000)
                    try? Data()
                        .adding(size: UInt16.self, collection: update)
                        .write(to: url, options: .atomic)
                } catch {
                    
                }
            }
        }
    }
    
    public mutating func clear() {
        items = []
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        try? FileManager.default.removeItem(at: url)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.items == rhs.items
    }
}
