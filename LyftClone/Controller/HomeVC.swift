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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
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
        
        //Create 3 vehicle annotation
        
        let lat = userLocation.coordinate.latitude
        let lng = userLocation.coordinate.longitude
        let offset = 0.00075
        
        let coord1 = CLLocationCoordinate2D(latitude: lat - offset, longitude: lng - offset)
        
        let coord2 = CLLocationCoordinate2D(latitude: lat, longitude: lng + offset)
        let coord3 = CLLocationCoordinate2D(latitude: lat, longitude: lng - offset)
        
        mapView.addAnnotations([
        VehicleAnnotation(coordinate: coord1),
        VehicleAnnotation(coordinate: coord2),
        VehicleAnnotation(coordinate: coord3)
        ])
        
    }
    //Car Image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        //Create our custom annotation view with vehicle image
        let reuseIdentifier = "VehicleAnnotation"
       var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }else{
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "car")
        
        annotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(arc4random_uniform(UInt32(360 * 180 / CGFloat.pi))))
        
        return annotationView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationVC = segue.destination as? LocationVC{
            locationVC.pickupLocation = currentUserLocation
        }
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
