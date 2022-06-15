import Foundation
import Dater

extension Array where Element == Date {
    var calendar: [Days<Bool>] {
        var dates = self
        return dates
            .calendar {
                dates.hits($0)
            }
    }
    
    mutating func hits(_ date: Date) -> Bool {
        while(!isEmpty && date > first!) {
            removeFirst()
        }
        return !isEmpty && Calendar.global.isDate(first!, inSameDayAs: date)
    }
}
