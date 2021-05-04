import Foundation
import Combine
import Archivable

#if DEBUG
    private let file = "WalkHero.debug.archive"
#else
    private let file = "WalkHero.archive"
#endif

extension Cloud where A == Archive {
    public static let shared = Self(manifest: .init(
                                        file: file,
                                        container: "iCloud.WalkHero",
                                        prefix: "hero_",
                                        title: "WalkHero"))
}
