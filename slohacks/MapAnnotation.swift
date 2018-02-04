//
//  MapAnnotation.swift
//  slohacks
//
//  Created by Joe Wijoyo on 2/3/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(locationName: String, coordinate: CLLocationCoordinate2D) {
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var title: String? {
        return locationName
    }
    
}
