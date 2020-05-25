//
//  LocationCell.swift
//  LyftClone
//
//  Created by David Murillo on 5/23/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet weak var addressLine1Lbl: UILabel!
    @IBOutlet weak var addressLine2Lbl: UILabel!
    
    func update(location:Location){
        addressLine1Lbl.text = location.title
        addressLine2Lbl.text = location.subtitle
    }

}
