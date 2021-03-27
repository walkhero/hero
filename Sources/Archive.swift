import Foundation
import Archivable

public struct Archive: Comparable, Archivable {
    var walks: [Walk]
    var challenges: Set<Challenge>
    var date: Date
    
    public var status: Status {
        walks.last.flatMap {
            $0.active ? .walking(-$0.date.timeIntervalSinceNow) : nil
        } ?? .none
    }
    
    public var last: DateInterval? {
        walks.last.map {
            .init(start: $0.date, duration: $0.duration)
        }
    }
    
    public var list: [Walk.Listed] {
        walks
            .map(\.duration)
            .filter {
                $0 > 0
            }
            .max()
            .map { duration in
                walks.map {
                    .init(date: $0.date, duration: $0.duration, percent: $0.duration / duration)
                }
            }?.reversed() ?? []
    }
    
    public var calendar: [Year] {
        walks.dates { dates, interval in
            interval.years { year, interval in
                .init(value: year, months: interval.months(year: year) { month, interval in
                    .init(value: month, days: interval.days(year: year, month: month) { day, date in
                        .init(value: day, hit: dates.hits(date))
                    })
                })
            }
        } ?? []
    }
    
    public var maxSteps: Int {
        walks.map(\.steps).max() ?? 0
    }
    
    public var steps: Steps {
        {
            { list, max in
                .init(values: list.map {
                    max > 0 ? .init($0) / max : 0
                }, max: Int(max))
            } ($0, Double($0.max() ?? 0))
        } (walks.suffix(Constants.steps.max).map(\.steps))
    }
    
    public var data: Data {
        Data()
            .adding(date.timestamp)
            .adding(UInt8(challenges.count))
            .adding(challenges.flatMap(\.data))
            .adding(UInt8(walks.count))
            .adding(walks.flatMap(\.data))
    }
    
    public init() {
        walks = []
        challenges = .init()
        date = .init()
    }
    
    public init(data: inout Data) {
        date = .init(timestamp: data.uInt32())
        challenges = .init((0 ..< .init(data.removeFirst())).map { _ in
            .init(data: &data)
        })
        walks = (0 ..< .init(data.removeFirst())).map { _ in
            .init(data: &data)
        }
    }
    
    public mutating func start() {
        guard case .none = status else { return }
        
        walks.append(.init())
        save()
    }
    
    public mutating func cancel() {
        guard case .walking = status else { return }
        
        walks.removeLast()
        save()
    }
    
    public mutating func end(steps: Int = 0, meters: Int = 0) {
        guard
            case let .walking(duration) = status,
            duration > 0
        else { return }
        
        walks = walks.mutating(index: walks.count - 1) {
            $0.end(steps: steps, meters: meters)
        }
        save()
    }
    
    public mutating func start(_ challenge: Challenge) {
        challenges.insert(challenge)
        save()
    }
    
    public mutating func stop(_ challenge: Challenge) {
        challenges.remove(challenge)
        save()
    }
    
    public func enrolled(_ challenge: Challenge) -> Bool {
        challenges.contains(challenge)
    }
    
    public static func < (lhs: Archive, rhs: Archive) -> Bool {
        lhs.date < rhs.date
    }
    
    private mutating func save() {
        date = .init()
        Memory.shared.save.send(self)
    }
}
