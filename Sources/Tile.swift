import Foundation
import Archivable

public struct Tile: Archivable, Hashable {
    public let x: Int
    public let y: Int
    
    public var data: Data {
        Data()
            .adding(UInt32(x))
            .adding(UInt32(y))
    }
    
    public init(data: inout Data) {
        x = .init(data.uInt32())
        y = .init(data.uInt32())
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
