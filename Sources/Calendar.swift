import Foundation

extension Calendar {
    var offset: Int32 {
        .init(timeZone.secondsFromGMT())
    }
    
    public func duration(from timestamp: UInt32) -> UInt16 {
        var finish = Date.now
        let start = Date(timestamp: timestamp)
        
        if dateComponents([.hour], from: start, to: finish).hour! > 9 {
            finish = date(byAdding: .hour, value: 1, to: start)!
        }
        
        return .init(finish.timeIntervalSince(start))
    }
}
