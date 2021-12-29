import Foundation

extension Array where Element == Bool {
    var dropLastIfFalse: Self {
        last == false ? dropLast() : self
    }
}
