import Foundation
import Archivable

struct Walk_v0: Storable {
    let timestamp: UInt32
    let offset: Int32
    let duration: UInt16
    let steps: UInt16
    let metres: UInt16
    
    var migrated: Walk {
        .init(timestamp: timestamp, offset: offset, duration: duration, steps: steps, metres: metres, calories: 0)
    }
    
    var data: Data {
        .init()
        .adding(timestamp)
        .adding(offset)
        .adding(duration)
        .adding(steps)
        .adding(metres)
    }
    
    init(data: inout Data) {
        timestamp = data.number()
        offset = data.number()
        duration = data.number()
        steps = data.number()
        metres = data.number()
    }
    
    init(timestamp: UInt32, offset: Int32 = Calendar.global.offset, duration: UInt16 = 0, steps: UInt16 = 0, metres: UInt16 = 0) {
        self.timestamp = timestamp
        self.offset = offset
        self.duration = duration
        self.steps = steps
        self.metres = metres
    }
}