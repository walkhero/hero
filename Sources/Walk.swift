import Foundation
import Archivable

public struct Walk: Equatable, Property {
    let date: Date
    let duration: TimeInterval
    let steps: Int
    let metres: Int
    
    var active: Bool {
        duration == 0
    }
    
    public var data: Data {
        Data()
            .adding(date)
            .adding(UInt16(duration))
            .adding(UInt16(steps))
            .adding(UInt16(metres))
    }
    
    init() {
        self.init(date: .init())
    }
    
    public init(data: inout Data) {
        date = data.date()
        duration = .init(data.uInt16())
        steps = .init(data.uInt16())
        metres = .init(data.uInt16())
    }
    
    init(date: Date, duration: TimeInterval = 0, steps: Int = 0, metres: Int = 0) {
        self.date = date
        self.duration = duration
        self.steps = steps
        self.metres = metres
    }
    
    func end(steps: Int, metres: Int) -> Self {
        .init(
            date: date,
            duration: {
                $0.timeIntervalSince(date)
            } (Calendar.current.dateComponents([.hour], from: date, to: .init()).hour! > Constants.walk.duration.max
                ? Calendar.current.date(byAdding: .hour, value: Constants.walk.duration.fallback, to: date)! : .init()),
            steps: steps,
            metres: metres)
    }
}
