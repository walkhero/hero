import Foundation

extension Array where Element == Int {
    var chart: Chart {
        { max, sum in
            .init(values: map {
                max > 0 ? .init($0) / max : 0
            }, max: .init(max), average: isEmpty ? 0 : .init(ceil(sum / .init(count))))
        } (Double(self.max() ?? 0), Double(reduce(0, +)))
    }
}
