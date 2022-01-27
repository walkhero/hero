import Foundation

extension Array where Element == Date {
    mutating func hits(_ date: Date) -> Bool {
        while(!isEmpty && date > first!) {
            removeFirst()
        }
        return !isEmpty && Calendar.global.isDate(first!, inSameDayAs: date)
    }
}
