import Foundation
import Archivable

public enum Defaults: String {
    case
    created,
    premium,
    hide,
    display

    public static var rate: Bool {
        wasCreated
            .map {
                let days = Calendar.current.dateComponents([.day], from: $0, to: .init()).day!
                return days > 1
            }
        ?? false
    }
    
    public static var froob: Bool {
        wasCreated
            .map {
                let days = Calendar.current.dateComponents([.day], from: $0, to: .init()).day!
                return days > 2
            }
        ?? false
    }
    
    public static func start() {
        if wasCreated == nil {
            wasCreated = .init()
        }
    }
    
    public static var isPremium: Bool {
        get { self[.premium] as? Bool ?? false }
        set { self[.premium] = newValue }
    }
    
    public static var shouldHide: Bool {
        get { self[.hide] as? Bool ?? true }
        set { self[.hide] = newValue }
    }
    
    public static var items: Display {
        get { (self[.display] as? Data).map { $0.prototype() } ?? .init() }
        set { self[.display] = newValue.data }
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
