import Foundation
import Archivable

public enum Challenge: UInt8, Identifiable, CaseIterable, Property {
    public var id: Self { self }
    
    case
    streak,
    steps,
    distance,
    map
    
    public var data: Data {
        Data()
            .adding(rawValue)
    }
    
    var string: String {
        "\(rawValue)"
    }
    
    public init(data: inout Data) {
        self.init(rawValue: data.removeFirst())!
    }
}
