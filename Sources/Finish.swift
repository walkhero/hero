import Foundation
import Archivable

public struct Finish: Equatable, Archiving {
    static let new = Self(duration: 0, streak: 0, steps: 0, distance: 0, map: 0)
    
    public let duration: TimeInterval
    public let streak: Int
    public let steps: Int
    public let metres: Int
    public let map: Int
    public let published: Bool
    
    public var data: Data {
        Data()
            .adding(UInt16(duration))
            .adding(UInt16(streak))
            .adding(UInt16(steps))
            .adding(UInt16(metres))
            .adding(UInt32(map))
            .adding(published)
    }
    
    public init(data: inout Data) {
        duration = .init(data.uInt16())
        streak = .init(data.uInt16())
        steps = .init(data.uInt16())
        metres = .init(data.uInt16())
        map = .init(data.uInt32())
        published = data.bool()
    }
    
    init(duration: TimeInterval, streak: Int, steps: Int, distance: Int, map: Int) {
        self.duration = duration
        self.streak = streak
        self.steps = steps
        self.metres = distance
        self.map = map
        self.published = false
    }
}
