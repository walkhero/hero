import XCTest
@testable import Hero

final class StreakTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testEmpty() {
        XCTAssertEqual(0, archive.chart.streak.max)
        XCTAssertFalse(archive.chart.calendar.isEmpty)
    }
    
    func testStreak() {
        let daysAgo12 = Calendar.global.date(byAdding: .day, value: -12, to: .init())!
        let daysAgo8 = Calendar.global.date(byAdding: .day, value: -8, to: .init())!
        let daysAgo7_5 = Calendar.global.date(byAdding: .hour, value: -12, to: Calendar.global.date(byAdding: .day, value: -7, to: .init())!)!
        let daysAgo7 = Calendar.global.date(byAdding: .day, value: -7, to: .init())!
        let daysAgo5 = Calendar.global.date(byAdding: .day, value: -5, to: .init())!
        let daysAgo3 = Calendar.global.date(byAdding: .day, value: -3, to: .init())!
        
        archive.walks = [
            .init(timestamp: daysAgo12.timestamp, duration: 1),
            .init(timestamp: daysAgo8.timestamp, duration: 1),
            .init(timestamp: daysAgo7_5.timestamp, duration: 1),
            .init(timestamp: daysAgo7.timestamp, duration: 1),
            .init(timestamp: daysAgo5.timestamp, duration: 1),
            .init(timestamp: daysAgo5.timestamp, duration: 1),
            .init(timestamp: daysAgo5.timestamp, duration: 1),
            .init(timestamp: daysAgo5.timestamp, duration: 1),
            .init(timestamp: daysAgo5.timestamp, duration: 1),
            .init(timestamp: daysAgo5.timestamp, duration: 1),
            .init(timestamp: daysAgo5.timestamp, duration: 1),
            .init(timestamp: daysAgo3.timestamp, duration: 1)]
        
        XCTAssertEqual(2, archive.chart.streak.max)
        XCTAssertEqual(0, archive.chart.streak.current)
        
        archive.walks.append(.init(timestamp: Calendar.global.date(byAdding: .day, value: -1, to: .init())!.timestamp, duration: 1))
        
        XCTAssertEqual(2, archive.chart.streak.max)
        XCTAssertEqual(1, archive.chart.streak.current)
        
        archive.walks.append(.init(timestamp: Date.now.timestamp, duration: 1))
        
        XCTAssertEqual(2, archive.chart.streak.max)
        XCTAssertEqual(2, archive.chart.streak.current)
    }
    
    func testToday() {
        let today = Calendar.global.component(.day, from: .init())
        XCTAssertEqual(.init(today), archive.chart.calendar.first?.items.flatMap { $0 }.first { $0.today }?.value)
    }
    
    func testYears() {
        let date1 = Calendar.global.date(from: .init(year: 2020, month: 12, day: 30, hour: 5))!
        let date2 = Calendar.global.date(from: .init(year: 2020, month: 12, day: 31, hour: 5))!
        let date3 = Calendar.global.date(from: .init(year: 2021, month: 1, day: 1, hour: 5))!
        let date4 = Calendar.global.date(from: .init(year: 2021, month: 1, day: 2, hour: 5))!
        
        archive.walks = [
            .init(timestamp: date1.timestamp, duration: 1),
            .init(timestamp: date2.timestamp, duration: 1),
            .init(timestamp: date3.timestamp, duration: 1),
            .init(timestamp: date4.timestamp, duration: 1)
        ]
        
        XCTAssertEqual(4, archive.chart.streak.max)
    }
    
    func testTimezones() {
        let timezone = Calendar.global.timeZone

        let berlin = TimeZone(identifier: "Europe/Berlin")!
        Calendar.global.timeZone = berlin
        let date1 = Calendar.global.date(from: .init(timeZone: berlin, year: 2021, month: 1, day: 2, hour: 1))!
        let walk1 = Walk(timestamp: date1.timestamp, duration: 1)
        
        let mexico = TimeZone(identifier: "America/Mexico_City")!
        Calendar.global.timeZone = mexico
        let date2 = Calendar.global.date(from: .init(timeZone: mexico, year: 2021, month: 1, day: 3, hour: 22))!
        let walk2 = Walk(timestamp: date2.timestamp, duration: 1)
        
        archive.walks = [walk1, walk2]
        
        Calendar.global.timeZone = berlin
        XCTAssertEqual(2, archive.chart.streak.max)
        
        let month = archive
            .chart
            .calendar
            .first { $0.year == 2021 && $0.month == 1 }!
        
        XCTAssertTrue(month.items.first![1].content)
        XCTAssertTrue(month.items.first![2].content)
        
        Calendar.global.timeZone = timezone
    }
    
    func testWalking() {
        XCTAssertEqual(0, archive.chart.streak.current)
        archive.walking = .now
        XCTAssertEqual(1, archive.chart.streak.current)
        archive.walks = [.init(timestamp: .now)]
        XCTAssertEqual(1, archive.chart.streak.current)
        archive.walks = [.init(timestamp: Calendar.global.date(byAdding: .day, value: -1, to: .now)!.timestamp)]
        XCTAssertEqual(2, archive.chart.streak.current)
        archive.walks = [.init(timestamp: Calendar.global.date(byAdding: .day, value: -2, to: .now)!.timestamp)]
        XCTAssertEqual(1, archive.chart.streak.current)
        archive.walking = 0
        XCTAssertEqual(0, archive.chart.streak.current)
    }
}
