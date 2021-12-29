import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var tiles: Set<Tile>
    
    public var streak: Streak {
        calendar.streak
    }
    
    public var calendar: [Year] {
        walks
            .map(\.timestamp)
            .map(Date.init(timestamp:))
            .calendar
    }
    
    var walks: [Walk]
    
    
    public var data: Data {
        .init()
        .adding(size: UInt32.self, collection: tiles)
        .adding(size: UInt32.self, collection: walks)
    }
    
    public init() {
        timestamp = 0
        tiles = []
        walks = []
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        tiles = .init(data.collection(size: UInt32.self))
        walks = data.collection(size: UInt32.self)
    }
}
