import Foundation

extension Year {
    public struct Month: Hashable {
        public let value: Int
        public let days: [[Day]]
    }
}
