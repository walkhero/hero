import Foundation

public struct Finish {
    public let duration: TimeInterval
    public let streak: Int
    public let steps: Int
    public let distance: Int
    public let map: Int
    
    public init(duration: TimeInterval, streak: Int, steps: Int, distance: Int, map: Int) {
        self.duration = duration
        self.streak = streak
        self.steps = steps
        self.distance = distance
        self.map = map
    }
}
