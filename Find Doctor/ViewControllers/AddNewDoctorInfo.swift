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
    @IBOutlet var doctorsName: UITextField!
    @IBOutlet var yoe: UITextField!
    @IBOutlet var specialization: UITextField!
    @IBOutlet var address: UITextView!
    @IBOutlet var medicalID: TextFieldShake!
    @IBOutlet var doctorProfilePic: UIImageView!
    let api = API(URL: "http://127.0.0.1:5000")
    override func viewDidLoad() {
        let width = 1.0
        medicalID.layer.borderWidth = width
        doctorsName.layer.borderWidth = width
        medicalID.layer.borderWidth = width
        yoe.layer.borderWidth = width
        specialization.layer.borderWidth = width
        address.layer.borderWidth = width
        if searchedMedicalID != "" {
            medicalID.text = searchedMedicalID
            medicalID.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func onClickButton() {
        var doctor : Doctor = Doctor(name: "", medicalid: "", specialization: "", address: "", yoe: 0)
        doctorsName.layer.borderColor = UIColor.white.cgColor
        medicalID.layer.borderColor =  UIColor.white.cgColor
        yoe.layer.borderColor =  UIColor.white.cgColor
        specialization.layer.borderColor =  UIColor.white.cgColor
        address.layer.borderColor =  UIColor.white.cgColor
        if let name = doctorsName.text{
            doctor.name = name
        }
        else{
            doctorsName.layer.borderColor = UIColor.red.cgColor
            return
        }
        if let medicalID = medicalID.text {
            doctor.medicalid = medicalID
        }
        else{
            medicalID.layer.borderColor = UIColor.red.cgColor
            return
        }
        if let yoeString = yoe.text {
            if let yoe = Int32(yoeString) {
                doctor.yoe = yoe
            }
            else{
                yoe.layer.borderColor = UIColor.red.cgColor
                return
            }
        }
        else{
            yoe.layer.borderColor = UIColor.red.cgColor
            return
        }
        if let specialization = specialization.text {
            doctor.specialization = specialization
        }
        else{
            specialization.layer.borderColor = UIColor.red.cgColor
            return
        }
        if let address = address.text {
            doctor.address = address
        }
        else {
            address.layer.borderColor = UIColor.red.cgColor
            return
        }
        let db = DoctorRealmDB()
        let foundDoctor = db.retriveDataWithId(medicalid: doctor.medicalid)
        if let _ = foundDoctor {
            medicalID.layer.borderColor = UIColor.red.cgColor
            medicalID.shake()
        }
        else{
            let presistabledata = PersistableDoctorInfo(doctor: doctor, isSynced: false)
            try! db.createData(presistabledata)
            api.syncDoctorInfoWithServer(doctorinfo: doctor, database: db)
            api.uploadImage(doctorProfilePic.image!, medicalID.text!)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
}

extension AddNewDoctorInfo : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        doctorProfilePic.image = image
        dismiss(animated: true)
    }
}
