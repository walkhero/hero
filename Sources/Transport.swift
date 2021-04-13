import Foundation

public struct Transport {
    public var message: [String : Any] {
        [Challenge.streak.string : streak,
         Challenge.steps.string : steps,
         Challenge.distance.string : distance,
         Challenge.map.string : map]
    }
    
    public let streak: Int
    public let steps: Int
    public let distance: Int
    public let map: Int
    
    public init(streak: Int, steps: Int, distance: Int, map: Int) {
        self.streak = streak
        self.steps = steps
        self.distance = distance
        self.map = map
    }
    
    public init(message: [String : Any]) {
        self.streak = message[.streak]
        self.steps = message[.steps]
        self.distance = message[.distance]
        self.map = message[.map]
    }
}

private extension Dictionary where Key == String, Value == Any {
    subscript(_ key: Challenge) -> Int {
        self[key.string] as? Int ?? 0
    }
}
