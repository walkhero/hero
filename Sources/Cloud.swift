import Foundation
import Combine
import Archivable

extension Cloud where A == Archive {
    public static var new: Self {
        .init(manifest: .init(
                file: file,
                container: "iCloud.WalkHero",
                prefix: "hero_",
                title: "WalkHero"))
    }
    
    public func start() {
        mutating {
            guard case .none = $0.status else { return }
            $0.walks.append(.init())
        }
    }
    
    public func finish(steps: Int, metres: Int, completion: @escaping (Finish) -> Void) {
        mutating(transform: {
            guard
                case let .walking(duration) = $0.status,
                duration > 0
            else { return nil }
            
            $0.walks = $0.walks.mutating(index: $0.walks.count - 1) {
                $0.end(steps: steps, metres: metres)
            }
            
            $0.area.formUnion($0.discover)
            $0.discover = []
            $0.finish = .init(duration: duration,
                              streak: max($0.calendar.streak.current, $0.finish.streak),
                              steps: max(steps, $0.finish.steps),
                              metres: max(metres, $0.finish.metres),
                              area: max($0.area.count, $0.finish.area))
            return $0.finish
        }, completion: completion)
    }
    
    public func cancel() {
        mutating {
            guard case .walking = $0.status else { return }
            $0.discover = []
            $0.walks.removeLast()
        }
    }
    
    public func start(_ challenge: Challenge) {
        mutating {
            $0.challenges.insert(challenge)
        }
    }
    
    public func stop(_ challenge: Challenge) {
        mutating {
            $0.challenges.remove(challenge)
        }
    }
    
    public func publish() {
        mutating {
            guard $0.finish.publish else { return }
            $0.finish = .new
        }
    }
    
    public func discover(_ tile: Tile) {
        ephemeral {
            guard
                !$0.area.contains(tile),
                !$0.discover.contains(tile)
            else { return }
            $0.discover.insert(tile)
        }
    }
}

#if DEBUG
    private let file = "WalkHero.debug.archive"
#else
    private let file = "WalkHero.archive"
#endif
