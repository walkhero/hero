import Foundation
import Archivable

public struct Walk: Equatable, Archivable {
    let date: Date
    let duration: TimeInterval
    let steps: Int
    let meters: Int
    
    var active: Bool {
        duration == 0
    }
    
    public var data: Data {
        Data()
            .adding(date.timestamp)
            .adding(UInt16(duration))
            .adding(UInt16(steps))
            .adding(UInt16(meters))
    }
    
    init() {
        self.init(date: .init())
    }
    
    public init(data: inout Data) {
        date = .init(timestamp: data.uInt32())
        duration = .init(data.uInt16())
        steps = .init(data.uInt16())
        meters = .init(data.uInt16())
    }
    
    init(date: Date, duration: TimeInterval = 0, steps: Int = 0, meters: Int = 0) {
        self.date = date
        self.duration = duration
        self.steps = steps
        self.meters = meters
    }
    
    func end(steps: Int, meters: Int) -> Self {
        .init(
            date: date,
            duration: {
                $0.timeIntervalSince(date)
            } (Calendar.current.dateComponents([.hour], from: date, to: .init()).hour! > Constants.walk.duration.max
                ? Calendar.current.date(byAdding: .hour, value: Constants.walk.duration.fallback, to: date)! : .init()),
            steps: steps,
            meters: meters)
    }
}
