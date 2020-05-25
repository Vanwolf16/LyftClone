//
//  VehicleAnnotation.swift
//  LyftClone
//
//  Created by David Murillo on 5/24/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import Foundation
import MapKit

class VehicleAnnotation:NSObject,MKAnnotation{
    var coordinate:CLLocationCoordinate2D
    
     init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
