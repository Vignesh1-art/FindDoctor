//
//  ViewController.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 09/05/22.
//

import UIKit

class MainViewController: UIViewController {
    let sheetViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sheet")
    var isSheetViewControllerPresented = false
    var searchedDoctorInfo : [Doctor] = []
    let db = DoctorCoreDataDB()
    @IBOutlet var topMainContraint: NSLayoutConstraint!
    @IBOutlet var searchedDoctorInfoDisplay: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchBarStyle = .minimal
        searchBar.layer.borderColor = UIColor.tintColor.cgColor
        searchBar.delegate = self
        searchedDoctorInfoDisplay.dataSource = self
        if db.getDataCount() == 0{
            let doctorInfo = LoadDataFromJSON.loadDoctors("DoctorsData")
            guard let info = doctorInfo else {
                return
            }
            for i in info{
                db.createData(i)
            }
        }
    }
    func presentSheetView() {
        if isSheetViewControllerPresented || sheetViewController.isBeingDismissed {
            return
        }
        if let sheet = sheetViewController.sheetPresentationController{
            sheet.detents = [.medium(),.large()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.preferredCornerRadius = 50
            sheet.prefersGrabberVisible = true
            sheet.selectedDetentIdentifier = .medium
            present(sheetViewController, animated: true)
            isSheetViewControllerPresented = true
        }
    }
    
    func dismissSheetView(){
        if !isSheetViewControllerPresented || sheetViewController.isBeingDismissed {
            return
        }
        sheetViewController.dismiss(animated: true)
        isSheetViewControllerPresented = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentSheetView()
    }
}

extension MainViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if let result = db.retriveDataWithFilter(specializationFilter: searchText) {
            searchedDoctorInfo = result
            searchedDoctorInfoDisplay.reloadData()
            if result.count > 0 {
                dismissSheetView()
                topMainContraint.constant = 0
            }
            else {
                //else it should be 0
                presentSheetView()
                topMainContraint.constant = 95
            }
        }
    }
}

extension MainViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchedDoctorInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "doctorinfocell", for: indexPath) as! DoctorInfoCell
        let doctorInfo = searchedDoctorInfo[indexPath.row]
        cell.name = doctorInfo.name
        cell.specialization = doctorInfo.specialization
        return cell
    }
    
    
}
