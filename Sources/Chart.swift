import Foundation
import Dater

public struct Chart {
    public let calendar: [Days<Bool>]
    public let streak: Streak
    public let duration: Item
    public let steps: Item
    public let metres: Item
    public let calories: Item
    public let walks: Int
    public let updated: DateInterval?
    
    init(walks: [Date],
         duration: Chart.Item,
         steps: Chart.Item,
         metres: Chart.Item,
         calories: Chart.Item,
         updated: DateInterval?) {
        
        self.calendar = walks.calendar
        self.streak = self.calendar.streak
        self.duration = duration
        self.steps = steps
        self.metres = metres
        self.calories = calories
        self.walks = walks.count
        self.updated = updated
    }
}
