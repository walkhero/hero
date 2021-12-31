import Foundation

extension Array where Element == Days {
    public var streak: Streak {
        isEmpty
            ? .zero
            : flatMap(\.items)
                .flatMap { $0 }
                .map(\.hit)
                .dropLast(Calendar.global.daysLeftMonth)
                .dropLastIfFalse
                .reduce(.zero) {
                    $1 ? $0.hit : $0.miss
                }
    }
}
