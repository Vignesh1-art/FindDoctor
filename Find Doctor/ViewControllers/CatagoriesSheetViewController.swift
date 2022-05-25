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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let block = {
            (doctors:[Doctor]?,error:Error?)->Void    in
            if let doctors = doctors {
                self.topDoctors = doctors
            }
            DispatchQueue.main.async {
                self.topDoctorTableView.reloadData()
            }
        }
        api.getTopDoctors(onTopDoctorsRecevied: block)
    }
}

extension CatagoriesSheetViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topDoctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topdoctorinfocell") as! TopDoctorsInfoCell
        let index = indexPath.row
        cell.name = topDoctors[index].name
        cell.yoe = topDoctors[index].yoe
        cell.specialization = topDoctors[index].specialization
        return cell
    }
    
    
}
