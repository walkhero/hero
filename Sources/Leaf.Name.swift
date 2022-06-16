extension Leaf {
    public enum Name: Int, CaseIterable {
        case
        green,
        earth,
        air,
        water,
        fire,
        wood,
        stone,
        glass,
        tin,
        copper,
        iron,
        steel,
        pyrite,
        silver,
        palladium,
        gold,
        platinum,
        silicon,
        fortytwo
        
        var next: Self {
            let index = Self.allCases.firstIndex(of: self)!
            return index < Self.allCases.count - 1 ? Self.allCases[index + 1] : .fortytwo
        }
    }
}
