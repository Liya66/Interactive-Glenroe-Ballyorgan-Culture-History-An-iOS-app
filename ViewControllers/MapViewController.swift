

import Foundation
import UIKit
import MapboxMaps

class MapViewController: BaseMapViewController {
    override func getCenterCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 52.310958, longitude: -8.429417)
    }

    override func getZoomLevel() -> CGFloat {
        return 11.0
    }

    override func getGeoJSONFileName() -> String {
        return "route"
    }
}
