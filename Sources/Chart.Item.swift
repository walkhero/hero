import Foundation

extension Chart {
    public struct Item {
        static let zero = Self(values: [], total: 0, max: 0, average: 0, trend: .stable)
        
        public let values: [Double]
        public let total: Int
        public let max: Int
        public let average: Int
        public let trend: Trend
    }
}
