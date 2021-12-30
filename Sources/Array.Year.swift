import Foundation

extension Array where Element == Year {
    var streak: Streak {
        isEmpty
            ? .zero
            : flatMap(\.months)
                .flatMap(\.days)
                .flatMap { $0 }
                .map(\.hit)
                .dropLast(Calendar.global.daysLeftMonth)
                .dropLastIfFalse
                .reduce(.zero) {
                    $1 ? $0.hit : $0.miss
                }
    }
}
