import Foundation

public struct Streak: Equatable {
    public static let zero = Self(maximum: 0, current: 0)
    public let maximum: Int
    public let current: Int
    
    private init(maximum: Int, current: Int) {
        self.maximum = maximum
        self.current = current
    }
    
    var hit: Self {
        .init(maximum: max(maximum, current + 1), current: current + 1)
    }
    
    var miss: Self {
        .init(maximum: maximum, current: 0)
    }
}
