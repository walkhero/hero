import Foundation

extension Calendar {
    static var global = current
    
    var offset: Int32 {
        .init(timeZone.secondsFromGMT())
    }
    
    var daysLeftMonth: Int {
        component(.day, from: date(
            byAdding: .day,
            value: -1,
            to: dateInterval(of: .month, for: .init())!.end)!)
        - component(.day, from: .init())
    }
    
    public func leadingWeekdays(year: Int, month: Int, day: Int) -> Int {
        {
            $0 < firstWeekday ? 7 - firstWeekday + $0 : $0 - firstWeekday
        } (component(.weekday, from: date(from: .init(year: year, month: month, day: day))!))
    }
    
    public func trailingWeekdays(year: Int, month: Int, day: Int) -> Int {
        {
            $0 < firstWeekday ? firstWeekday - 1 - $0 : 6 + firstWeekday - $0
        } (component(.weekday, from: date(from: .init(year: year, month: month, day: day))!))
    }
    
    func duration(from timestamp: UInt32) -> UInt16 {
        var finish = Date.now
        let start = Date(timestamp: timestamp)
        
        if dateComponents([.hour], from: start, to: finish).hour! > 9 {
            finish = date(byAdding: .hour, value: 1, to: start)!
        }
        
        return .init(finish.timeIntervalSince(start))
    }
}
