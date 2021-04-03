import XCTest
@testable import Hero

final class StreakTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .new
        Memory.shared = .init()
        Memory.shared.subs = .init()
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
            .init(date: daysAgo12, duration: 1),
            .init(date: daysAgo8, duration: 1),
            .init(date: daysAgo7_5, duration: 1),
            .init(date: daysAgo7, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo5, duration: 1),
            .init(date: daysAgo3, duration: 1)]
        
        XCTAssertEqual(2, archive.calendar.streak.maximum)
        XCTAssertEqual(0, archive.calendar.streak.current)
        
        archive.walks.append(.init(date: Calendar.current.date(byAdding: .day, value: -1, to: .init())!, duration: 1))
        
        XCTAssertEqual(2, archive.calendar.streak.maximum)
        XCTAssertEqual(1, archive.calendar.streak.current)
        
        archive.walks.append(.init(date: .init(), duration: 1))
        
        XCTAssertEqual(2, archive.calendar.streak.maximum)
        XCTAssertEqual(2, archive.calendar.streak.current)
    }
    
    func testCalendar() {
        let monday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 15))!
        let wednesday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 17))!
        let thursday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 18))!
        let saturday = Calendar.current.date(from: .init(year: 2021, month: 3, day: 20))!
        
        archive.walks = [
            .init(date: monday, duration: 1),
            .init(date: wednesday, duration: 1),
            .init(date: thursday, duration: 1),
            .init(date: saturday, duration: 1),
            .init(date: saturday, duration: 1)]
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
        XCTAssertEqual(today, archive.calendar.first?.months.first?.days.flatMap { $0 }.first(where: { $0.today })?.value)
    }
}
