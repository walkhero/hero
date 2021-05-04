import Foundation
import Archivable

public struct Archive: Archived {
    public static let new = Self()
    public var date: Date
    public internal(set) var finish: Finish
    var walks: [Walk]
    var challenges: Set<Challenge>
    var area: Set<Tile>
    var discover = Set<Tile>()
    
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
                    .init(date: $0.date.addingTimeInterval($0.duration), duration: $0.duration, percent: $0.duration / duration)
                }
            }?.reversed() ?? []
    }
    
    public var calendar: [Year] {
        walks.map(\.date).calendar
    }
    
    public var maxSteps: Int {
        walks.map(\.steps).max() ?? 0
    }
    
    public var maxMetres: Int {
        walks.map(\.metres).max() ?? 0
    }
    
    public var steps: Chart {
        walks.suffix(Constants.chart.max).map(\.steps).chart
    }
    
    public var metres: Chart {
        walks.suffix(Constants.chart.max).map(\.metres).chart
    }
    
    public var tiles: Set<Tile> {
        area.union(discover)
    }
    
    public var data: Data {
        Data()
            .adding(date)
            .adding(UInt8(challenges.count))
            .adding(challenges.flatMap(\.data))
            .adding(UInt32(walks.count))
            .adding(walks.flatMap(\.data))
            .adding(UInt32(area.count))
            .adding(area.flatMap(\.data))
            .adding(finish.data)
    }
    
    init() {
        walks = []
        challenges = .init()
        area = .init()
        date = .init(timeIntervalSince1970: 0)
        finish = .new
    }
    
    public init(data: inout Data) {
        date = data.date()
        challenges = .init((0 ..< .init(data.removeFirst())).map { _ in
            .init(data: &data)
        })
        walks = (0 ..< .init(data.uInt32())).map { _ in
            .init(data: &data)
        }
        area = .init((0 ..< .init(data.uInt32())).map { _ in
            .init(data: &data)
        })
        finish = .init(data: &data)
    }
    
    public mutating func start() {
        guard case .none = status else { return }
        
        walks.append(.init())
//        save()
    }
    
    public mutating func cancel() {
        guard case .walking = status else { return }
        
        discover = []
        walks.removeLast()
//        save()
    }
    
    public mutating func publish() {
        guard finish.publish else { return }
        finish = .new
//        save()
    }
    
    public mutating func discover(_ tile: Tile) {
        guard
            !area.contains(tile),
            !discover.contains(tile)
        else { return }
        discover.insert(tile)
    }
    
    public mutating func finish(steps: Int = 0, metres: Int = 0) {
        guard
            case let .walking(duration) = status,
            duration > 0
        else { return }
        
        walks = walks.mutating(index: walks.count - 1) {
            $0.end(steps: steps, metres: metres)
        }
        
        area.formUnion(discover)
        discover = []
        finish = .init(duration: duration,
                       streak: max(calendar.streak.current, finish.streak),
                       steps: max(steps, finish.steps),
                       metres: max(metres, finish.metres),
                       area: max(area.count, finish.area))
        
//        save()
    }
    
    public mutating func start(_ challenge: Challenge) {
        challenges.insert(challenge)
//        save()
    }
    
    public mutating func stop(_ challenge: Challenge) {
        challenges.remove(challenge)
//        save()
    }
    
    public func enrolled(_ challenge: Challenge) -> Bool {
        challenges.contains(challenge)
    }
}
