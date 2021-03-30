import MapKit

struct Constants {
    struct map {
        static let zoom = Double(18)
        static let tile = MKMapRect.world.width / pow(2, zoom)
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
