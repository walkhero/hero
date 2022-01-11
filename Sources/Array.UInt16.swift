import Foundation

extension Array where Element == UInt16 {
    var chart: Chart {
        { max, sum in
            .init(values: map {
                max > 0 ? .init($0) / max : 0
            }, max: Int(max), average: isEmpty ? 0 : .init(ceil(sum / .init(count))))
        } (Double(self.max() ?? 0), .init(reduce(0, +)))
    }
}
