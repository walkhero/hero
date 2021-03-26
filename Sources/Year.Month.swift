import Foundation
import Archivable

extension Year {
    public struct Month: Hashable {
        public let value: Int
        public let days: [[Day]]
    }
}
