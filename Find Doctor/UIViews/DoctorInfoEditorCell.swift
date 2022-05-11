//
//  DoctorInfoEditorCell.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 11/05/22.
//

import Foundation
import UIKit
class DoctorInfoEditorCell : UITableViewCell {
    @IBOutlet var medicalIDDisplay: UILabel!
    @IBOutlet var nameDisplay: UILabel!
    
    var name : String {
        set {
            nameDisplay.text = newValue
        }
        
        get {
            return nameDisplay.text!
        }
    }
    
    var medicalID : String {
        set {
            medicalIDDisplay.text = newValue
        }
        
        get {
            return medicalIDDisplay.text!
        }
    }
    
    
    @IBAction func onClickEdit() {
    }
}
