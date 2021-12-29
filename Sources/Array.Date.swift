import Foundation

extension Array where Element == Date {
    public var calendar: [Year] {
        ranges { dates, interval in
            interval.years { year, interval in
                .init(value: year, months: interval.months(year: year) { month, interval in
                    .init(value: month, days: interval.days(year: year, month: month) { day, date in
                        .init(value: day, today: Calendar.current.isDateInToday(date), hit: dates.hits(date))
                    })
                })
            }
        }
    }
    
    private func ranges<T>(transform: (inout [Date], DateInterval) -> T) -> T {
        var array = self
        return {
            transform(&array, .init(start: array.first ?? $0, end: $0))
        } (.init())
    }
    
    private mutating func hits(_ date: Date) -> Bool {
        while(!isEmpty && date > first!) {
            removeFirst()
        }
        return !isEmpty && Calendar.current.isDate(first!, inSameDayAs: date)
    }
}
