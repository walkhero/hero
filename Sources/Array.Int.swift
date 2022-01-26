import Foundation

extension Array where Element == Int {
    var chart: Chart {
        { max, sum, average, previous in
                .init(values: map { max > 0 ? .init($0) / Double(max) : 0 },
                      total: sum,
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
    
    private var _max: Element {
        self.max() ?? 0
    }
    
    private var _sum: Element {
        reduce(0, +)
    }
    
    private var _average: Element {
        isEmpty ? 0 : .init(ceil(.init(_sum) / Double(count)))
    }
}
