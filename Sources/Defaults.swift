import Foundation

public enum Defaults: String {
    case
    rated,
    created,
    premium,
    hide,
    follow

    public static var action: Action {
        if let created = wasCreated {
            let days = Calendar.global.dateComponents([.day], from: created, to: .init()).day!
            if !hasRated && days > 4 {
                hasRated = true
                return .rate
            } else if hasRated && !isPremium && days > 5 {
                return .froob
            }
        } else {
            wasCreated = .init()
        }
        return .none
    }
    
    public static var isPremium: Bool {
        get { self[.premium] as? Bool ?? false }
        set { self[.premium] = newValue }
    }
    
    public static var hasRated: Bool {
        get { self[.rated] as? Bool ?? false }
        set { self[.rated] = newValue }
    }
    
    public static var shouldHide: Bool {
        get { self[.hide] as? Bool ?? true }
        set { self[.hide] = newValue }
    }
    
    public static var shouldFollow: Bool {
        get { self[.follow] as? Bool ?? true }
        set { self[.follow] = newValue }
    }
    
    static var wasCreated: Date? {
        get { self[.created] as? Date }
        set { self[.created] = newValue }
    }
    
    private static subscript(_ key: Self) -> Any? {
        get { UserDefaults.standard.object(forKey: key.rawValue) }
        set { UserDefaults.standard.setValue(newValue, forKey: key.rawValue) }
    }
}
