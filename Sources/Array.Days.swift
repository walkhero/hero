import Foundation
import Dater

extension Array where Element == Days<Bool> {
    var streak: Streak {
        isEmpty
            ? .init(max: 0, current: 0)
            : flatMap(\.items)
                .flatMap { $0 }
                .map(\.content)
                .dropLast(Calendar.global.daysLeftMonth)
                .dropLastIfFalse
                .reduce(.init(max: 0, current: 0)) {
                    $1 ? $0.hit : $0.miss
                }
    }
}
