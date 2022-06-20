import Foundation

public struct Summary: Identifiable {
    public let duration: Int
    public let steps: Int
    public let metres: Int
    public let calories: Int
    public let squares: Int
    public let streak: Int
    public let id = UUID()
}
