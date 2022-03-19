import Foundation
import Archivable
import Dater

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var squares: Set<Squares.Item>
    
    public var calendar: [Days<Bool>] {
        var dates = walks.map(\.date)
        return dates
            .calendar {
                dates.hits($0)
            }
    }
    
    public var updated: DateInterval? {
        walks
            .last
            .map {
                .init(start: .init(timestamp: $0.timestamp), duration: .init($0.duration))
            }
    }
    
    public var duration: Chart {
        walks.map { .init($0.duration) }.chart
    }
    
    public var steps: Chart {
        walks.map { .init($0.steps) }.chart
    }
    
    public var metres: Chart {
        walks.map { .init($0.metres) }.chart
    }
    
    public var walking: Date? {
        walks
            .last
            .flatMap {
                $0.duration == 0 ? .init(timestamp: $0.timestamp) : nil
            }
    }
    
    public var count: Int {
        walks.count
    }
    
    var walks: [Walk]
    
    public var data: Data {
        .init()
        .adding(size: UInt32.self, collection: squares)
        .adding(size: UInt32.self, collection: walks)
    }
    
    public init() {
        timestamp = 0
        squares = []
        walks = []
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        squares = .init(data.collection(size: UInt32.self))
        walks = data.collection(size: UInt32.self)
    }
}
