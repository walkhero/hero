import Foundation
import CoreLocation

public actor Squares {
    static let url = FileManager
        .default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("Squares.cache")
    
    public private(set) var items = Set<Item>()
    private(set) var task: Task<Void, Never>?
    
    public init() {
        if FileManager.default.fileExists(atPath: Self.url.path),
           var data = try? Data(contentsOf: Self.url),
           !data.isEmpty {
            items = .init(data.collection(size: UInt16.self))
        }
    }
    
    public func add(locations: [CLLocation]) -> Bool {
        let update = items
            .union(locations
                    .map(\.coordinate)
                    .map(Item.init))
        
        guard update != items else { return false }
        
        items = update
        
        task?.cancel()
        task = Task {
            do {
                try await Task.sleep(nanoseconds: 1000_000_000)
                
                guard !Task.isCancelled else { return }
                
                try Data()
                    .adding(size: UInt16.self, collection: update)
                    .write(to: Self.url, options: .atomic)
                
            } catch { }
        }
        
        return true
    }
    
    public func clear() {
        task?.cancel()
        items = []
        
        if FileManager.default.fileExists(atPath: Self.url.path) {
            try? FileManager.default.removeItem(at: Self.url)
        }
    }
}
