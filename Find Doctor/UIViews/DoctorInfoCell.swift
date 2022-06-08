//
//  DoctorInfoCell.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 10/05/22.
//

import Foundation
import UIKit
class DoctorInfoCell : UICollectionViewCell {
    @IBOutlet var nameDisplay: UILabel!
    @IBOutlet var specializationDisplay: UILabel!
    @IBOutlet var doctorProfile: UIImageView!
    
    var name : String {
        set {
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
        get{
            return specializationDisplay.text!
        }
    }
    
}
