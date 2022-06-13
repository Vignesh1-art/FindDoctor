//
//  CatagoriesSheetViewController.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 09/05/22.
//

import Foundation
import UIKit
import SwiftUI

class CatagoriesSheetViewController : UIViewController {
    @IBOutlet var bottomStackView: UIStackView!
    var buttomStackViewHiddenState = true
    @IBOutlet var mainStackHeightConstraint: NSLayoutConstraint!
    @IBOutlet var topDoctorTableView: UITableView!
    var topDoctors : [Doctor] = []
    let api = API(URL: "http://127.0.0.1:5000")
    var image:UIImage?
    @IBOutlet var dentistCatagoryImage: UIImageView!
    @IBOutlet var eyeCatagoryImage: UIImageView!
    @IBOutlet var cardiologistCatagoryImage: UIImageView!
    @IBOutlet var skinCatagoryImage: UIImageView!
    @IBAction func onClickBooked(_ sender: UIButton) {
        sender.setTitle("Booked", for: UIControl.State.normal)
    }
    @IBAction func onClickSeeAll(_ senderButton : UIButton) {
        buttomStackViewHiddenState = !buttomStackViewHiddenState
        if buttomStackViewHiddenState == true {
            mainStackHeightConstraint.constant = 150
            senderButton.setTitle("See all", for: UIControl.State.normal)
        }
        else{
            mainStackHeightConstraint.constant = 311
            senderButton.setTitle("Hide", for: UIControl.State.normal)
        }
        bottomStackView.isHidden = buttomStackViewHiddenState
    }
    
    override func viewDidLoad() {
        bottomStackView.isHidden = true
        mainStackHeightConstraint.constant = 150
        topDoctorTableView.dataSource = self
        
        let tapDentistImage = UITapGestureRecognizer(target: self, action: #selector(onTapDentistCatagoryImage(tapGestureRecognizer:)))
        dentistCatagoryImage.isUserInteractionEnabled = true
        dentistCatagoryImage.addGestureRecognizer(tapDentistImage)
        
        let tapEyeImage = UITapGestureRecognizer(target: self, action: #selector(onTapEyeCatagoryImage(tapGestureRecognizer:)))
        eyeCatagoryImage.isUserInteractionEnabled = true
        eyeCatagoryImage.addGestureRecognizer(tapEyeImage)
        
        let tapCardiologistImage = UITapGestureRecognizer(target: self, action: #selector(onTapCardiologistCatagoryImage(tapGestureRecognizer:)))
        cardiologistCatagoryImage.isUserInteractionEnabled = true
        cardiologistCatagoryImage.addGestureRecognizer(tapCardiologistImage)
        
        let tapSkinImage = UITapGestureRecognizer(target: self, action: #selector(onTapSkinCatagoryImage(tapGestureRecognizer:)))
        skinCatagoryImage.isUserInteractionEnabled = true
        skinCatagoryImage.addGestureRecognizer(tapSkinImage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let doctors = api.getTopDoctors() {
            topDoctors = doctors
            topDoctorTableView.reloadData()
        }
        else{
            print("Unable to load top doctors")
        }
    }
    
    @objc func onTapDentistCatagoryImage(tapGestureRecognizer: UITapGestureRecognizer){
        guard let allTopDoctors = api.getTopDoctors() else {
            return
        }
        topDoctors.removeAll()
        for doctor in allTopDoctors {
            if doctor.specialization == "Dentist"{
                topDoctors.append(doctor)
            }
        }
        topDoctorTableView.reloadData()
    }
    
    @objc func onTapEyeCatagoryImage(tapGestureRecognizer: UITapGestureRecognizer){
        guard let allTopDoctors = api.getTopDoctors() else {
            return
        }
        topDoctors.removeAll()
        for doctor in allTopDoctors {
            if doctor.specialization == "Ophthalmologist"{
                topDoctors.append(doctor)
            }
        }
        topDoctorTableView.reloadData()
    }
    
    @objc func onTapCardiologistCatagoryImage(tapGestureRecognizer: UITapGestureRecognizer){
        guard let allTopDoctors = api.getTopDoctors() else {
            return
        }
        topDoctors.removeAll()
        for doctor in allTopDoctors {
            if doctor.specialization == "Cardiologists"{
                topDoctors.append(doctor)
            }
        }
        topDoctorTableView.reloadData()
    }
    
    @objc func onTapSkinCatagoryImage(tapGestureRecognizer: UITapGestureRecognizer){
        guard let allTopDoctors = api.getTopDoctors() else {
            return
        }
        topDoctors.removeAll()
        for doctor in allTopDoctors {
            if doctor.specialization == "Dermatologist"{
                topDoctors.append(doctor)
            }
        }
        topDoctorTableView.reloadData()
    }
}

extension CatagoriesSheetViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topDoctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topdoctorinfocell") as! TopDoctorsInfoCell
        cell.nameDisplay.accessibilityIdentifier = "name"
        let index = indexPath.row
        cell.name = topDoctors[index].name
        cell.yoe = topDoctors[index].yoe
        cell.specialization = topDoctors[index].specialization
        let profilePic = api.downloadImage(topDoctors[index].medicalid)
        if let profilePic = profilePic {
            cell.doctorProfilePic = profilePic
        }
        return cell
    }
    
}
