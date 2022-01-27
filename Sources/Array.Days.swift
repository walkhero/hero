import Foundation
import Dater

extension Array where Element == Days<Bool> {
    public var streak: Streak {
        isEmpty
            ? .zero
            : flatMap(\.items)
                .flatMap { $0 }
                .map(\.content)
                .dropLast(Calendar.global.daysLeftMonth)
                .dropLastIfFalse
                .reduce(.zero) {
                    $1 ? $0.hit : $0.miss
                }
    }
}
