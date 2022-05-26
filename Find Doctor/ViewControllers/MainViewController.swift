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
    let db = DoctorRealmDB()
    @IBOutlet var topMainContraint: NSLayoutConstraint!
    @IBOutlet var searchedDoctorInfoDisplay: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBAction func onClickBooked(_ sender: UIButton) {
        sender.setTitle("Booked", for: UIControl.State.normal)
    }
    @IBAction func onClickPharma(_ sender: UIBarButtonItem) {
        dismissSheetView()
        let pharmaViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editdoctorsb")
        navigationController?.pushViewController(pharmaViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchBarStyle = .minimal
        searchBar.layer.borderColor = UIColor.tintColor.cgColor
        searchBar.delegate = self
        searchedDoctorInfoDisplay.dataSource = self
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (screenWidth/2)-15, height: 178)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        searchedDoctorInfoDisplay.collectionViewLayout = layout
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
        sheetViewController.isModalInPresentation = true
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
