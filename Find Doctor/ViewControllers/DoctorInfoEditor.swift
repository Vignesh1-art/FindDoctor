//
//  DoctorInfoEditor.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 11/05/22.
//

import Foundation
import UIKit
class DoctorInfoEditor : UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var doctorInfoEditorTableView: UITableView!
    @IBOutlet var addButton: UIButton!
    var doctorInfo : [Doctor]=[]
    let db = DoctorRealmDB()
    let api = API(URL: "http://127.0.0.1:5000")
    
    @IBAction func onClickAddButton() {
        let addDoctorInfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "adddoctorinfo") as! AddNewDoctorInfo
        addDoctorInfoViewController.searchedMedicalID = searchBar.text ?? ""
        navigationController?.pushViewController(addDoctorInfoViewController, animated: true)
    }
    
    override func viewDidLoad() {
        searchBar.delegate = self
        doctorInfoEditorTableView.dataSource = self
        addButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doctorInfoEditorTableView.reloadData()
        let queue = DispatchQueue(label: "sync thread")
        queue.async {
            let db = DoctorRealmDB()
            let doctorinfo = db.retriveAllData()
            guard let doctors = doctorinfo else {
                return
            }
            for doctor in doctors {
                do {
                    let syncStatus = try db.getSyncStatus(medicalid: doctor.medicalid)
                    if !syncStatus {
                        self.api.syncDoctorInfoWithServer(doctorinfo: doctor, database: self.db)
                    }
                }
                catch {
                    print("Error while syncing the data")
                }
            }
            
                }
    }
}
extension DoctorInfoEditor : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if let info = db.retriveDataWithFilter(medicalIdFilter: searchText) {
            doctorInfo = info
            if doctorInfo.count == 0 {
                addButton.isEnabled = true
            }
            else{
                addButton.isEnabled = false
            }
            doctorInfoEditorTableView.reloadData()
        }
    }
}

extension DoctorInfoEditor : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        doctorInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doctorinfoeditorcell") as! DoctorInfoEditorCell
        let currentDoctorInfo = doctorInfo[indexPath.row]
        cell.name = currentDoctorInfo.name
        cell.medicalID = currentDoctorInfo.medicalid
        return cell
    }
}
