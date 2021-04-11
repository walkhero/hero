import Foundation
import Combine
import Archivable

public struct Repository: Repo {
    public static let memory = Memory<Self>()
    public typealias A = Archive
    
    #if DEBUG
        public static let file = URL.manifest("WalkHero.debug.archive")
    #else
        public static let file = URL.manifest("WalkHero.archive")
    #endif
    
    public static let container = "iCloud.WalkHero"
    public static let prefix = "hero_"
    public static internal(set) var override: PassthroughSubject<A, Never>?
}
