import Foundation
import Archivable
import Dater

struct Archive_v0: Arch {
    var timestamp: UInt32
    var squares: Set<Squares.Item>
    var walks: [Walk_v0]
    
    var data: Data {
        .init()
        .adding(size: UInt32.self, collection: squares)
        .adding(size: UInt32.self, collection: walks)
    }
    
    init() {
        timestamp = 0
        squares = []
        walks = []
    }
    
    init(version: UInt8, timestamp: UInt32, data: Data) async {
        self.timestamp = 0
        squares = []
        walks = []
    }
}
