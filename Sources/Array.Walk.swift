import Foundation
import Dater

extension Array where Element == Walk {
    func chart(walking: Bool) -> Chart {
        .init(walks: map(\.date) + (walking ? [.now] : []),
              duration: compactMap { $0.duration == 0 ? nil : Int($0.duration) }.item,
              steps: compactMap { $0.steps == 0 ? nil : Int($0.steps) }.item,
              metres: compactMap { $0.metres == 0 ? nil : Int($0.metres) }.item,
              calories: compactMap { $0.calories == 0 ? nil : Int($0.calories) }.item,
              updated: last.map { .init(start: .init(timestamp: $0.timestamp), duration: .init($0.duration)) })
    }
}

private extension Array where Element == Int {
    var item: Chart.Item {
        { max, sum, average, previous in
            .init(total: sum,
                  max: max,
                  average: average,
                  trend: count > 1
                  ? previous > average
                      ? .decrease
                      : previous < average
                          ? .increase
                          : .stable
                  : .stable)
        } (_max, _sum, _average, dropLast()._average)
    }
    
    var _max: Element {
        self.max() ?? 0
    }
    
    var _sum: Element {
        reduce(0, +)
    }
    
    var _average: Element {
        isEmpty ? 0 : .init(ceil(.init(_sum) / Double(count)))
    }
}
