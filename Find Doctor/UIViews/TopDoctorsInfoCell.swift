//
//  TopDoctorsInfoCell.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 10/05/22.
//

import Foundation
import UIKit
class TopDoctorsInfoCell : UITableViewCell {
    @IBOutlet var nameDisplay: UILabel!
    @IBOutlet var specializationDisplay: UILabel!
    @IBOutlet var yoeDisplay: UILabel!
    @IBOutlet var doctorProfile: UIImageView!
    var yoeCache : Int32 = 0
    var name : String {
        set{
            nameDisplay.text = newValue
        }
        get {
            return nameDisplay.text!
        }
    }
    
    var specialization : String {
        set {
            specializationDisplay.text = newValue
        }
        get {
            specializationDisplay.text!
        }
    }
    
    var yoe : Int32 {
        set {
            yoeDisplay.text = String(newValue) + " years of experience"
            yoeCache = newValue
        }
        
        get {
            return yoeCache
        }
    }
    
    var doctorProfilePic : UIImage! {
        set {
            doctorProfile.image = newValue
        }
        get {
            //Do not use this
            return doctorProfile.image
        }
    }
}
