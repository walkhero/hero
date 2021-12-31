import Foundation

extension Array where Element == Date {
    public var calendar: [Days] {
        ranges { dates, interval in
            interval
                .years { year, interval in
                    interval
                        .months(year: year) { month, interval in
                            .init(year: year,
                                  month: month,
                                  items: interval
                                    .days(year: year, month: month) { day, date in
                                        .init(value: day,
                                              today: Calendar.global.isDateInToday(date),
                                              hit: dates.hits(date))
                                    })
                        }
                }
        }
    }
    
    private func ranges<T>(transform: (inout [Date], DateInterval) -> T) -> T {
        var array = self
        return transform(&array, .init(start: array.first ?? .now, end: .now))
    }
    
    private mutating func hits(_ date: Date) -> Bool {
        while(!isEmpty && date > first!) {
            removeFirst()
        }
        return !isEmpty && Calendar.global.isDate(first!, inSameDayAs: date)
    }
}
