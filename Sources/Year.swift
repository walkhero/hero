import Foundation
import Archivable

public struct Year: Hashable {
    public let value: Int
    public let months: [Month]
}
