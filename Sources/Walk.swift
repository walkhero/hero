import Foundation
import Archivable

struct Walk: Storable {
    let timestamp: UInt32
    let duration: UInt16
    let steps: UInt16
    let metres: UInt16
    
    var data: Data {
        Data()
            .adding(timestamp)
            .adding(duration)
            .adding(steps)
            .adding(metres)
    }
    
    init() {
        self.init(timestamp: Date.now.timestamp)
    }
    
    init(data: inout Data) {
        timestamp = data.number()
        duration = data.number()
        steps = data.number()
        metres = data.number()
    }
    
    init(timestamp: UInt32, duration: UInt16 = 0, steps: UInt16 = 0, metres: UInt16 = 0) {
        self.timestamp = timestamp
        self.duration = duration
        self.steps = steps
        self.metres = metres
    }
}
