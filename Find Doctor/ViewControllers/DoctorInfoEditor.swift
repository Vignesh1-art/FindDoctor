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
    
    @IBAction func onClickAddButton() {
        let addDoctorInfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "adddoctorinfo")
        navigationController?.pushViewController(addDoctorInfoViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        doctorInfoEditorTableView.dataSource = self
        addButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        doctorInfoEditorTableView.reloadData()
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
