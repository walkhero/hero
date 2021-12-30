import Foundation

extension DateInterval {
    private var _end: Date { Calendar.global.date(byAdding: .second, value: -1, to: end)! }
    
    func years<T>(transform: (Int, Self) -> T) -> [T] {
        (Calendar.global.component(.year, from: start) ... Calendar.global.component(.year, from: end))
            .map {
                transform($0,
                          Calendar.global.dateInterval(
                            of: .year,
                            for: Calendar.global.date(from: .init(year: $0))!)!.intersection(with: self)!)
            }
    }
    
    func months<T>(year: Int, transform: (Int, Self) -> T) -> [T] {
        (Calendar.global.component(.month, from: start) ... Calendar.global.component(.month, from: _end))
            .map {
                transform($0, Calendar.global.dateInterval(
                    of: .month,
                    for: Calendar.global.date(from: .init(year: year, month: $0))!)!)
            }
    }
    
    func days<T>(year: Int, month: Int, transform: (Int, Date) -> T) -> [[T]] {
        (Calendar.global.component(.weekOfMonth, from: start) ... Calendar.global.component(.weekOfMonth, from: _end))
            .map {
                Calendar.global.dateInterval(
                    of: .weekOfMonth,
                    for: Calendar.global.date(from: .init(year: year, month: month, weekday: Calendar.global.firstWeekday, weekOfMonth: $0))!)!
                    .intersection(with: self)!
            }
            .map {
                (Calendar.global.component(.day, from: $0.start) ... Calendar.global.component(.day, from: $0._end))
                    .map {
                        transform($0, Calendar.global.date(from: .init(year: year, month: month, day: $0))!)
                    }
            }
    }
}
