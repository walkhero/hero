import MapKit

public struct Constants {
    struct map {
        static let tile = MKMapRect.world.width / pow(2, 20)
    }
    
    struct walk {
        struct duration {
            static let max = 9
            static let fallback = 1
        }
    }
    
    public struct chart {
        public static let max = 20
    }
}
