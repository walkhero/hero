import Foundation
import Archivable
import Dater

public struct Archive: Arch {
    public var timestamp: UInt32
    
    public static var version: UInt8 {
        1
    }
    
    public internal(set) var walking: UInt32
    
    public var tiles: Set<Squares.Item> {
        get {
            .init(squares
                .mutating {
                    $0
                        .collection(size: UInt32.self)
                })
        }
        set {
            squares = .init()
                .adding(size: UInt32.self, collection: newValue)
        }
    }
    
    public var calendar: [Days<Bool>] {
        var dates = walks.map(\.date)
        return dates
            .calendar {
                dates.hits($0)
            }
    }
    
    public var chart: Chart {
        walks.chart
    }
    
    public var count: Int {
        walks.count
    }
    
    public var data: Data {
        .init()
        .adding(walking)
        .wrapping(size: UInt32.self, data: squares)
        .wrapping(size: UInt32.self, data: history)
    }
    
    var walks: [Walk] {
        get {
            history
                .mutating {
                    $0
                        .collection(size: UInt32.self)
                }
        }
        set {
            history = .init()
                .adding(size: UInt32.self, collection: newValue)
        }
    }
    
    private var squares: Data
    private var history: Data
    
    public init() {
        timestamp = 0
        walking = 0
        squares = .init().adding(UInt32())
        history = .init().adding(UInt32())
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == 0 {
            walking = 0
            squares = .init()
                .adding(size: UInt32.self, collection: data.collection(size: UInt32.self) as [Squares.Item])
            history = .init()
                .adding(size: UInt32.self, collection: (data.collection(size: UInt32.self) as [Walk_v0]).map(\.migrated))
        } else {
            walking = data.number()
            squares = data.unwrap(size: UInt32.self)
            history = data.unwrap(size: UInt32.self)
        }
    }
}
