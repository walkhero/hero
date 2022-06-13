import Foundation

public struct Chart: Equatable {
    public static let zero = Self(streak: .zero,
                                  duration: .zero,
                                  steps: .zero,
                                  metres: .zero,
                                  calories: .zero,
                                  updated: nil)
    
    public let streak: Streak
    public let duration: Item
    public let steps: Item
    public let metres: Item
    public let calories: Item
    public let updated: DateInterval?
}
