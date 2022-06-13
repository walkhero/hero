import Foundation

public enum Defaults: String {
    case
    created,
    premium,
    hide

    public static var froob: Bool {
        if let created = wasCreated {
            let days = Calendar.current.dateComponents([.day], from: created, to: .init()).day!
            return !isPremium && days > 2
        } else {
            wasCreated = .init()
        }
        return false
    }
    
    public static var rate: Bool {
        if let created = wasCreated {
            let days = Calendar.current.dateComponents([.day], from: created, to: .init()).day!
            return days > 1
        } else {
            wasCreated = .init()
        }
        return false
    }
    
    public static var isPremium: Bool {
        get { self[.premium] as? Bool ?? false }
        set { self[.premium] = newValue }
    }
    
    public static var shouldHide: Bool {
        get { self[.hide] as? Bool ?? true }
        set { self[.hide] = newValue }
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
