//
//  SearchResultDisplayViewController.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 10/05/22.
//

import Foundation
import UIKit

class SearchResultDisplay : UIViewController {
    @IBOutlet var serachResultCollectionView: UICollectionView!
    private var doctors = [Doctor]()
    var searchText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        serachResultCollectionView.dataSource = self
        let db = DoctorCoreDataDB()
        if let doctorData = db.retriveDataWithFilter(specializationFilter: searchText) {
            doctors = doctorData
        }
    }
}

extension SearchResultDisplay : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "doctorinfocell", for: indexPath) as! DoctorInfoCell
        let index = indexPath.row
        cell.name = doctors[index].name
        cell.specialization = doctors[index].specialization
        return cell
    }
    
    
}
