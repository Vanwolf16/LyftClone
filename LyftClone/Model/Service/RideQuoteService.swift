//
//  RideQuoteService.swift
//  LyftClone
//
//  Created by David Murillo on 5/23/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import Foundation
import CoreLocation

class RideQuoteService{
    static let shared = RideQuoteService()
    
    private init() {}
    
    func getQuotes(pickupLocation:Location,dropoffLocation:Location) -> [RideQuote]{
        
        let location1 = CLLocation(latitude: pickupLocation.lat, longitude: pickupLocation.lng)
        let location2 = CLLocation(latitude: dropoffLocation.lat, longitude: dropoffLocation.lng)
        
        //Meters
        let distance = location1.distance(from: location2)
        let mininumAmount = 3.0
        
        return [
            RideQuote(thumbnail: "ride-shared", name: "Shared", capacity: "1-2", price: mininumAmount + (distance * 0.5), time: Date()),
            RideQuote(thumbnail: "ride-compact", name: "Shared", capacity: "4", price: mininumAmount + (distance * 0.9), time: Date()),
            RideQuote(thumbnail: "ride-large", name: "Shared", capacity: "6", price: mininumAmount + (distance * 1.5), time: Date())
        
        ]
        
    }
    
}
