//
//  LocationVC.swift
//  LyftClone
//
//  Created by David Murillo on 5/24/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController,UITextFieldDelegate,MKLocalSearchCompleterDelegate{
    
    var locations = [Location]()
    var pickupLocation:Location?
    var dropoffLocation:Location?
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var dropOffTF: UITextField!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        locations = LocationService.shared.getRecentLocations()
        
        dropOffTF.becomeFirstResponder()
        dropOffTF.delegate = self
        searchCompleter.delegate = self
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lastestString = (textField.text as! NSString).replacingCharacters(in: range, with: string)
        if lastestString.count > 3{
             searchCompleter.queryFragment = lastestString
        }
       
        return true
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        //reload tableview
        myTableView.reloadData()
    }
    
    @IBAction func cancelDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension LocationVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.isEmpty ? locations.count : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else { return UITableViewCell() }
        if searchResults.isEmpty{
            let location = locations[indexPath.row]
            cell.update(location: location)
        }else{
            let searchResult = searchResults[indexPath.row]
            cell.update(searchResult: searchResult)
        }
     
        return cell
    }
    
    
}
