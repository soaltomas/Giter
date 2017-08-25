//
//  MapPin.swift
//  Giter
//
//  Created by Артем Полушин on 26.08.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import Foundation
import MapKit

class MapPin: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
