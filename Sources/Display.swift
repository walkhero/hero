import Foundation
import Archivable

public struct Display: Storable, Equatable {
    public internal(set) var items: [Item]
    public internal(set) var max: Bool
    public internal(set) var average: Bool
    
    public var data: Data {
        .init()
        .adding(size: UInt8.self, collection: items)
        .adding(max)
        .adding(average)
    }
    
    public init(data: inout Data) {
        items = data.collection(size: UInt8.self)
        max = data.bool()
        average = data.bool()
    }
    
    init() {
        items = Key.allCases.map { .init(key: $0, value: true) }
        max = true
        average = true
    }
}
