import Foundation

extension Array where Element == Int {
    var chart: Chart {
        { max in
            .init(values: map {
                max > 0 ? .init($0) / max : 0
            }, max: .init(max))
        } (.init(self.max() ?? 0))
    }
}
