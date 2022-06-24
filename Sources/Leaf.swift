import Foundation

public struct Leaf {
    private static let map = generate()
    
    public let name: Name
    public let squares: Int
    public let next: Int
    public let current: Int
    public let total: Int
    
    public var badges: [(name: Name, squares: Int)] {
        Name
            .allCases
            .filter { $0.rawValue <= name.rawValue }
            .reversed()
            .map {
                (name: $0, squares: Self.map[$0]!)
            }
    }
    
    public init(squares: Int) {
        name = Self.name(for: squares)
        let next = name.next
        self.next = Self.map[next]!
        self.total = self.next - Self.map[name]!
        current = squares - Self.map[name]!
        self.squares = squares
    }
    
    private static func name(for squares: Int) -> Name {
        map
            .filter {
                $0.value <= squares
            }
            .max {
                $0.value < $1.value
            }?
            .key
        ?? .fortytwo
    }
    
    private static func generate() -> [Name : Int] {
        Name
            .allCases
            .reduce(into: [:]) { result, name in
                switch name.rawValue {
                case 0:
                    result[name] = 0
                case 1:
                    result[name] = 128
                default:
                    result[name] = Int(pow(2, Double(name.rawValue) + 6))
                }
            }
    }
}
