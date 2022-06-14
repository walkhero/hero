import Foundation
import Archivable
import Dater

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var walking: UInt32
    
    public static var version: UInt8 {
        1
    }
    
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
        walks.calendar
    }
    
    public var chart: Chart {
        walks.chart(squares: tiles.count)
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
            
            squares = .init()
                .adding(size: UInt32.self, collection: data.collection(size: UInt32.self) as [Squares.Item])
            
            var walks = (data.collection(size: UInt32.self) as [Walk_v0]).map(\.migrated)
            
            if walks.last?.duration == 0,
               let timestamp = walks.popLast()?.timestamp {
                walking = timestamp
            } else {
                walking = 0
            }
            
            history = .init()
                .adding(size: UInt32.self, collection: walks)
            
        } else {
            walking = data.number()
            squares = data.unwrap(size: UInt32.self)
            history = data.unwrap(size: UInt32.self)
        }
    }
}
