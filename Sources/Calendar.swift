import Foundation

extension Calendar {
    var daysLeftMonth: Int {
        component(.day, from: date(byAdding: .day, value: -1, to: dateInterval(of: .month, for: .init())!.end)!) - component(.day, from: .init())
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
