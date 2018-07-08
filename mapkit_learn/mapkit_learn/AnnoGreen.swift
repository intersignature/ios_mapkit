//
//  AnnoGreen.swift
//  mapkit_learn
//
//  Created by Sirichai Binchai on 8/7/2561 BE.
//  Copyright © 2561 Sirichai Binchai. All rights reserved.
//

import Foundation
import MapKit

class AnnoGreen: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
