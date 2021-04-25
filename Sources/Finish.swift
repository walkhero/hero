import Foundation
import Archivable

public struct Finish: Equatable, Property {
    static let new = Self(publish: false)
    
    public let duration: TimeInterval
    public let streak: Int
    public let steps: Int
    public let metres: Int
    public let area: Int
    public let publish: Bool
    
    public var data: Data {
        Data()
            .adding(UInt16(duration))
            .adding(UInt16(streak))
            .adding(UInt16(steps))
            .adding(UInt16(metres))
            .adding(UInt32(area))
            .adding(publish)
    }
    
    public init(data: inout Data) {
        duration = .init(data.uInt16())
        streak = .init(data.uInt16())
        steps = .init(data.uInt16())
        metres = .init(data.uInt16())
        area = .init(data.uInt32())
        publish = data.bool()
    }
    
    init(duration: TimeInterval = 0, streak: Int = 0, steps: Int = 0, metres: Int = 0, area: Int = 0, publish: Bool = true) {
        self.duration = duration
        self.streak = streak
        self.steps = steps
        self.metres = metres
        self.area = area
        self.publish = publish
    }
}
