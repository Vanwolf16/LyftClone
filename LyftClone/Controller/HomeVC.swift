//
//  HomeVC.swift
//  LyftClone
//
//  Created by David Murillo on 5/23/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HomeVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myMapView: MKMapView!
    
    
    
    var locations = [Location]()
    
    //Maps
    var locationManager:CLLocationManager?
    var currentUserLocation:Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myMapView.delegate = self
        
        let recentLocations = LocationService.shared.getRecentLocations()
        
        locations = [recentLocations[0],recentLocations[1]]
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationManager?.startUpdatingLocation()
        }
        
        
    }
    
    //Map Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let firstLocation = locations.first!
        currentUserLocation = Location(title: "Current Location", subtitle: "", lat: firstLocation.coordinate.latitude, lng: firstLocation.coordinate.longitude)
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager?.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //Zoom in to the user location
        let distance = 200.0
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
    }
    
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else {return UITableViewCell()}
        
        let location = locations[indexPath.row]
        cell.update(location: location)
        return cell
        
    }
    
    
}