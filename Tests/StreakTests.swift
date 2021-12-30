import XCTest
@testable import Hero

final class StreakTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testEmpty() {
        XCTAssertEqual(.zero, archive.calendar.streak)
        XCTAssertNotNil(archive.calendar.first?.months.first?.days)
    }
    
    func testStreak() {
        let daysAgo12 = Calendar.current.date(byAdding: .day, value: -12, to: .init())!
        let daysAgo8 = Calendar.current.date(byAdding: .day, value: -8, to: .init())!
        let daysAgo7_5 = Calendar.current.date(byAdding: .hour, value: -12, to: Calendar.current.date(byAdding: .day, value: -7, to: .init())!)!
        let daysAgo7 = Calendar.current.date(byAdding: .day, value: -7, to: .init())!
        let daysAgo5 = Calendar.current.date(byAdding: .day, value: -5, to: .init())!
        let daysAgo3 = Calendar.current.date(byAdding: .day, value: -3, to: .init())!
        
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
        
        XCTAssertEqual(2, archive.calendar.streak.maximum)
        XCTAssertEqual(0, archive.calendar.streak.current)
        
        archive.walks.append(.init(timestamp: Calendar.current.date(byAdding: .day, value: -1, to: .init())!.timestamp, duration: 1))
        
        XCTAssertEqual(2, archive.calendar.streak.maximum)
        XCTAssertEqual(1, archive.calendar.streak.current)
        
        archive.walks.append(.init(timestamp: Date.now.timestamp, duration: 1))
        
        XCTAssertEqual(2, archive.calendar.streak.maximum)
        XCTAssertEqual(2, archive.calendar.streak.current)
    }
    
    func testCalendar() {
        let monday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 15))!
        let wednesday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 17))!
        let thursday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 18))!
        let saturday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 20))!
        
        archive.walks = [
            .init(timestamp: monday.timestamp, duration: 1),
            .init(timestamp: wednesday.timestamp, duration: 1),
            .init(timestamp: thursday.timestamp, duration: 1),
            .init(timestamp: saturday.timestamp, duration: 1),
            .init(timestamp: saturday.timestamp, duration: 1)]
        XCTAssertEqual(.init(value: 3, days: [
            [.init(value: 1, today: false, hit: false),
             .init(value: 2, today: false, hit: false),
             .init(value: 3, today: false, hit: false),
             .init(value: 4, today: false, hit: false),
             .init(value: 5, today: false, hit: false),
             .init(value: 6, today: false, hit: false),
             .init(value: 7, today: false, hit: false)],
            [.init(value: 8, today: false, hit: false),
             .init(value: 9, today: false, hit: false),
             .init(value: 10, today: false, hit: false),
             .init(value: 11, today: false, hit: false),
             .init(value: 12, today: false, hit: false),
             .init(value: 13, today: false, hit: false),
             .init(value: 14, today: false, hit: false)],
            [.init(value: 15, today: false, hit: true),
             .init(value: 16, today: false, hit: false),
             .init(value: 17, today: false, hit: true),
             .init(value: 18, today: false, hit: true),
             .init(value: 19, today: false, hit: false),
             .init(value: 20, today: false, hit: true),
             .init(value: 21, today: false, hit: false)],
            [.init(value: 22, today: false, hit: false),
             .init(value: 23, today: false, hit: false),
             .init(value: 24, today: false, hit: false),
             .init(value: 25, today: false, hit: false),
             .init(value: 26, today: false, hit: false),
             .init(value: 27, today: false, hit: false),
             .init(value: 28, today: false, hit: false)],
             [.init(value: 29, today: false, hit: false),
             .init(value: 30, today: false, hit: false),
             .init(value: 31, today: false, hit: false)]
        ]), archive.calendar.first!.months.first!)
    }
    
    func testToday() {
        let today = Calendar.current.component(.day, from: .init())
        XCTAssertEqual(today, archive.calendar.first?.months.first?.days.flatMap { $0 }.first { $0.today }?.value)
    }
    
    func testYears() {
        let date1 = Calendar.current.date(from: .init(year: 2020, month: 12, day: 30, hour: 5))!
        let date2 = Calendar.current.date(from: .init(year: 2020, month: 12, day: 31, hour: 5))!
        let date3 = Calendar.current.date(from: .init(year: 2021, month: 1, day: 1, hour: 5))!
        let date4 = Calendar.current.date(from: .init(year: 2021, month: 1, day: 2, hour: 5))!
        
        archive.walks = [
            .init(timestamp: date1.timestamp, duration: 1),
            .init(timestamp: date2.timestamp, duration: 1),
            .init(timestamp: date3.timestamp, duration: 1),
            .init(timestamp: date4.timestamp, duration: 1)
        ]
        
        XCTAssertEqual(4, archive.calendar.streak.maximum)
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
        XCTAssertEqual(2, archive.calendar.streak.maximum)
        
        let month = archive
            .calendar
            .first { $0.value == 2021 }!
            .months
            .first { $0.value == 1 }!
        
        XCTAssertTrue(month.days.first![1].hit)
        XCTAssertTrue(month.days.first![2].hit)
        
        Calendar.global.timeZone = timezone
    }
}
