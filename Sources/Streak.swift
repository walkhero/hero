import Foundation

public struct Streak: Equatable {
    public static let zero = Self(max: 0, current: 0)
    public let max: Int
    public let current: Int
    
    private init(max: Int, current: Int) {
        self.max = max
        self.current = current
    }
    
    var hit: Self {
        .init(max: Swift.max(max, current + 1), current: current + 1)
    }
    
    var miss: Self {
        .init(max: max, current: 0)
    }
}
