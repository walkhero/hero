import Foundation

extension DateInterval {
    private var calendar: Calendar { .current }
    private var _end: Date { calendar.date(byAdding: .second, value: -1, to: end)! }
    
    func years<T>(transform: (Int, Self) -> T) -> [T] {
        (calendar.component(.year, from: start) ... calendar.component(.year, from: end))
            .map {
                transform($0, calendar.dateInterval(
                            of: .year,
                            for: calendar.date(from: .init(year: $0))!)!
                            .intersection(with: self)!)
            }
    }
    
    func months<T>(year: Int, transform: (Int, Self) -> T) -> [T] {
        (calendar.component(.month, from: start) ... calendar.component(.month, from: _end))
            .map {
                transform($0, calendar.dateInterval(
                            of: .month,
                            for: calendar.date(from: .init(year: year, month: $0))!)!)
            }
    }
    
    func days<T>(year: Int, month: Int, transform: (Int, Date) -> T) -> [[T]] {
        (calendar.component(.weekOfMonth, from: start) ... calendar.component(.weekOfMonth, from: _end))
            .map {
                calendar.dateInterval(
                    of: .weekOfMonth,
                    for: calendar.date(from: .init(year: year, month: month, weekday: calendar.firstWeekday, weekOfMonth: $0))!)!
                    .intersection(with: self)!
            }
            .map {
                (calendar.component(.day, from: $0.start) ... calendar.component(.day, from: $0._end))
                    .map {
                        transform($0, calendar.date(from: .init(year: year, month: month, day: $0))!)
                    }
            }
    }
}
