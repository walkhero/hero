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
    
    public func enrolled(_ challenge: Challenge) -> Bool {
        challenges.contains(challenge)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.date.timestamp == rhs.date.timestamp
            && lhs.walks == rhs.walks
    }
}
