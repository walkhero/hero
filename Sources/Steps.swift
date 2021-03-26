import Foundation

public struct Steps: Equatable {
    public static let zero = Self(values: [], max: 0)
    
    public let values: [Double]
    public let max: Int
}
