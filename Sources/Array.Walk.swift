import Foundation

extension Array where Element == Walk {
    func dates<T>(transform: (inout [Date], DateInterval) -> T) -> T? {
        var array = map(\.date)
        return array.first.map {
            transform(&array, .init(start: $0, end: .init()))
        }
    }
}
