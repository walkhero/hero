import Foundation
import Archivable

extension Array where Element == Bool {
    var dropLastIfFalse: Self {
        last == false ? dropLast() : self
    }
}
