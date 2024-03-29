import Foundation
import Archivable

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
    
    public var chart: Chart {
        walks.chart(walking: walking > 0)
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
        
        if version == 1 {
            walking = data.number()
            squares = data.unwrap(size: UInt32.self)
            history = data.unwrap(size: UInt32.self)
        } else {
            walking = 0
            squares = .init().adding(UInt32())
            history = .init().adding(UInt32())
        }
    }
}
