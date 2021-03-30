import MapKit

public struct Constants {
    public struct map {
        public static let zoom = 20
        static let tile = with(zoom: zoom)
        
        static func with(zoom: Int) -> Double {
            MKMapRect.world.width / pow(2, .init(zoom))
        }
    }
    
    struct walk {
        struct duration {
            static let max = 9
            static let fallback = 1
        }
    }
    
    struct chart {
        static let max = 20
    }
}
