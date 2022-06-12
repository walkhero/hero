import Foundation
import Archivable

struct Walk: Storable {
    let timestamp: UInt32
    let offset: Int32
    let duration: UInt16
    let steps: UInt16
    let metres: UInt16
    let calories: UInt32
    
    var data: Data {
        .init()
        .adding(timestamp)
        .adding(offset)
        .adding(duration)
        .adding(steps)
        .adding(metres)
        .adding(calories)
    }
    
    init() {
        self.init(timestamp: Date.now.timestamp)
    }
    
    init(data: inout Data) {
        timestamp = data.number()
        offset = data.number()
        duration = data.number()
        steps = data.number()
        metres = data.number()
        calories = data.number()
    }
    
    init(timestamp: UInt32,
         offset: Int32 = Calendar.global.offset,
         duration: UInt16 = 0,
         steps: UInt16 = 0,
         metres: UInt16 = 0,
         calories: UInt32 = 0) {
        
        self.timestamp = timestamp
        self.offset = offset
        self.duration = duration
        self.steps = steps
        self.metres = metres
        self.calories = calories
    }
    
    var date: Date {
        .init(timeIntervalSince1970: .init(timestamp) - .init(Calendar.global.offset - offset))
    }
}
