import Foundation
import Archivable

public enum Challenge: UInt8, CaseIterable, Archivable {
    case
    streak,
    steps,
    distance,
    map
    
    public var data: Data {
        Data()
            .adding(rawValue)
    }
    
    public init(data: inout Data) {
        self.init(rawValue: data.removeFirst())!
    }
}
