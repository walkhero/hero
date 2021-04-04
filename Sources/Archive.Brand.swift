import Foundation

extension Archive {
    public static var brand: Self {
        var archive = Self()
        archive.challenges = .init(Challenge.allCases)
        archive.walks = (0 ..< 70)
            .filter { _ in
                Int.random(in: 0 ..< 2) == 0
            }
            .map {
                .init(date: Calendar.current.date(byAdding: .day, value: -$0, to: .init())!,
                     duration: .random(in: 15 * 60 ..< 180 * 60),
                     steps: .random(in: 200 ..< 9000),
                     metres: .random(in: 200 ..< 6000))
            }
        archive.date = .init()
        return archive
    }
}
