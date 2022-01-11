import Foundation

public struct Chart: Equatable {
    public static let zero = Self(values: [], max: 0, average: 0)
    
    public let values: [Double]
    public let max: Int
    public let average: Int
}
