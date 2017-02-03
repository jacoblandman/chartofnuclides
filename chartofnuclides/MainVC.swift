//
//  MainVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/2/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: BorderlessSearchBar!
    @IBOutlet weak var tableView: UITableView!
    var elements = [Element]()
    var filteredElements = [Element]()
    var storedOffsets = [Int: CGFloat]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        elements = DataService.instance.parse_json()
        filteredElements = elements
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ElementCell", for: indexPath) as? ElementCell {
            return cell
        } else {
            print("JACOB: Returning a regular UITAbleViewCell")
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this function gets called just before the cell is about to be displayed. 
        // we can set the collection view delegate/datasource here
        
        guard let tableViewCell = cell as? ElementCell else { return }
        
        // set the collection view delgates to this class
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        
        // set the view offset
        // if it hasn't been stored yet then set it to 0
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? ElementCell else { return }
        
        // set the content offset for each collectionView
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredElements[collectionView.tag].filteredIsotopes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IsotopeCell", for: indexPath) as? IsotopeCell {
            
            let isotope = filteredElements[collectionView.tag].filteredIsotopes[indexPath.row]
            cell.updateCell(isotope: isotope)
            return cell
        } else {
            print("JACOB: Returning a regular collection view cell")
            return UICollectionViewCell()
        }
    }
    
}

extension MainVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text == nil || searchBar.text == "" {
            
            filteredElements = elements
            for element in filteredElements {
                element.filteredIsotopes = element.isotopes
            }
            tableView.reloadData()
            view.endEditing(true)
            
        } else {
            
            // we already know there is text
            let lower = searchBar.text!.lowercased().replacingOccurrences(of: " ", with: "")
            
            for element in filteredElements {
                element.filteredIsotopes = element.isotopes.filter({
                    (($0.element.name) + ($0.atomicNumber)).lowercased().range(of: lower) != nil ||
                    (($0.element.symbol) + ($0.atomicNumber)).lowercased().range(of: lower) != nil
                })
            }
            
            filteredElements = filteredElements.filter({ $0.filteredIsotopes.count != 0})
            
            tableView.reloadData()
        }
    }

}

