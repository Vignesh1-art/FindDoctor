//
//  AddNewDoctorInfo.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 11/05/22.
//

import Foundation
import UIKit
class AddNewDoctorInfo : UIViewController{
    var searchedMedicalID = ""
    @IBOutlet var medicalID: UITextField!
    @IBOutlet var doctorsName: UITextField!
    @IBOutlet var yoe: UITextField!
    @IBOutlet var specialization: UITextField!
    @IBOutlet var address: UITextView!
    
    @IBAction func onClickButton() {
        var doctor : Doctor = Doctor(name: "", medicalid: "", specialization: "", address: "", yoe: 0)
        doctor.name = doctorsName.text!
        doctor.medicalid = medicalID.text!
        doctor.yoe = Int32(yoe.text!)!
        doctor.specialization = specialization.text!
        doctor.address = address.text!
        let db = DoctorCoreDataDB()
        db.createData(doctor)
        medicalID.layer.borderColor = UIColor.red.cgColor
        navigationController?.popViewController(animated: true)
    }
    
}
