//
//  ViewController.swift
//  Find Doctor
//
//  Created by Vignesh Shetty on 09/05/22.
//

import UIKit

class MainViewController: UIViewController {
    let sheetViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sheet")
    var searchDisplay : SearchResultDisplay?
    @IBOutlet var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchBarStyle = .minimal
        searchBar.layer.borderColor = UIColor.tintColor.cgColor
        
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchDisplay = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchdisplay") as? SearchResultDisplay
        if let sheet = sheetViewController.sheetPresentationController{
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.preferredCornerRadius = 50
            sheet.prefersGrabberVisible = true
        }
        sheetViewController.isModalInPresentation = true
        present(sheetViewController, animated: true)
    }


}

extension MainViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        sheetViewController.dismiss(animated: true)
        guard let searchResult = searchDisplay else{
            return
        }
        if let searchText = searchBar.text {
            searchResult.searchText = searchText
        }
        navigationController?.pushViewController(searchResult, animated: true)
    }
}
