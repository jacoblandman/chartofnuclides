//
//  MainVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/2/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var searchBar: BorderlessSearchBar!
    @IBOutlet weak var tableView: UITableView!
    var elements = ElementManager.instance.elements
    var filteredElements = [Element]()
    var storedOffsets = [String: CGFloat]()
    var inSearchMode = false
    let maskZoomTransition = MZMaskZoomTransitioningDelegate()
    var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        self.transitioningDelegate = maskZoomTransition
        navigationController!.transitioningDelegate = maskZoomTransition
        
        tapGesture.isEnabled = false
        
        filteredElements = elements
    }
    
    @IBAction func infoPressed(_ sender: Any) {
        performSegue(withIdentifier: "infoPVC", sender: nil)
    }
    
    @IBAction func endEditing(_ sender: Any) {
        view.endEditing(true)
        tapGesture.isEnabled = false
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
        tableViewCell.collectionViewOffset = storedOffsets[filteredElements[indexPath.row].symbol] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? ElementCell else { return }
        
        // set the content offset for each collectionView
        if !isSearching {
          storedOffsets[filteredElements[indexPath.row].symbol] = tableViewCell.collectionViewOffset
        }
    }

    @IBAction func tappedScreen(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredElements[collectionView.tag].filteredIsotopes.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IsotopeCell", for: indexPath) as? IsotopeCell {
            
            if indexPath.row == 0 {
                let element = filteredElements[collectionView.tag]
                cell.updateCell(element: element)
            } else {
                let isotope = filteredElements[collectionView.tag].filteredIsotopes[indexPath.row - 1]
                cell.updateCell(isotope: isotope)
            }
            
            return cell
        } else {
            print("JACOB: Returning a regular collection view cell")
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! IsotopeCell
        performSegue(withIdentifier: "DetailNuclideVC", sender: cell)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? IsotopeCell {
            UIView.animate(withDuration: 0.05) { [] in
                cell.highlight()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? IsotopeCell {
            UIView.animate(withDuration: 0.05) { [] in
                cell.unhighlight()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailNuclideVC" {
            self.navigationController?.transitioningDelegate = maskZoomTransition
            self.transitioningDelegate = maskZoomTransition
            if let destination = segue.destination as? DetailNuclideVC {
                if let transitioningDelegate = navigationController?.transitioningDelegate as? MZMaskZoomTransitioningDelegate {
                    if let isotopeCell = sender as? IsotopeCell {
                        transitioningDelegate.smallView = isotopeCell
                        destination.transitioningDelegate = maskZoomTransition
                        destination.modalPresentationStyle = UIModalPresentationStyle.custom
                        destination.isotope = isotopeCell.isotope
                        destination.element = isotopeCell.element
                    }
                }
            }
        }
    }
}

extension MainVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        tapGesture.isEnabled = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        isSearching = true
        if searchBar.text == nil || searchBar.text == "" {
            
            storeOffsets()
            resetElements()
            tableView.reloadData()
            tableView.layoutIfNeeded()
            setOffsets()
            view.endEditing(true)
            
        } else {
        
            // reset everything
            // set content offsets
            resetElements()
            
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
            tableView.layoutIfNeeded()
            tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            
        }
        
        isSearching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        storeOffsets()
        return true
    }

    func resetElements() {
        filteredElements = elements
        for element in filteredElements {
            element.filteredIsotopes = element.isotopes
        }
        tableView.reloadData()
    }
    
    func setOffsets() {
        if let visibleCells = tableView.visibleCells as? [ElementCell] {
            let visibleCellCount = visibleCells.count
            for i in 0..<visibleCellCount {
                visibleCells[i].collectionViewOffset = storedOffsets[filteredElements[i].symbol] ?? 0
            }
        }
    }
    
    func storeOffsets() {
        if let visibleCells = tableView.visibleCells as? [ElementCell] {
            let visibleCellCount = visibleCells.count
            for i in 0..<visibleCellCount {
                storedOffsets[filteredElements[i].symbol] = visibleCells[i].collectionViewOffset
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        tapGesture.isEnabled = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        tapGesture.isEnabled = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

