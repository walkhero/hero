import Foundation

extension Archive {
    public static var brand: Self {
        var archive = Self()
        archive.challenges = .init(Challenge.allCases)
        archive.walks = (1 ..< 70)
            .filter { _ in
                Int.random(in: 0 ..< 2) == 0
            }
            .map {
                .init(date: Calendar.current.date(byAdding: .day, value: -$0, to: .init())!,
                     duration: .random(in: 50 * 60 ..< 180 * 60),
                     steps: .random(in: 2000 ..< 9000),
                     metres: .random(in: 2000 ..< 6000))
            }
            .reversed()
        archive.date = .init()
        return archive
    }
}
