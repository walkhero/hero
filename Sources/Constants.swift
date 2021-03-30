import MapKit

struct Constants {
    struct map {
        static let tile = with(zoom: 20)
        
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
