import Foundation
import Archivable

extension Display {
    public struct Item: Storable, Equatable {
        public var key: Key
        public var value: Bool
        
        public var data: Data {
            .init()
            .adding(key.rawValue)
            .adding(value)
        }
        
        public init(data: inout Data) {
            key = .init(rawValue: data.number())!
            value = data.bool()
        }
        
        init(key: Key, value: Bool) {
            self.key = key
            self.value = value
        }
    }
}
