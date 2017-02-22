//
//  PopupSearchVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/14/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class PopupSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var delegate: SendDataToPreviousControllerDelegate?
    
    var elements = ElementManager.instance.elements
    var filteredElements = [Element]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.superview?.layer.cornerRadius = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        filteredElements = elements
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredElements[section].filteredIsotopes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupIsotopeCell", for: indexPath) as! PopupIsotopeCell
        let isotope = filteredElements[indexPath.section].filteredIsotopes[indexPath.row]
        cell.updateCell(isotope: isotope)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let isotope = filteredElements[indexPath.section].filteredIsotopes[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        // send the selected isotope back to the previous view controller
        delegate?.sendDataToA(data: isotope)
        _ = navigationController?.popViewController(animated: true)
    }
}

extension PopupSearchVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            resetElements()
            view.endEditing(true)
            
        } else {
            
            // reset everything
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
        }
    }
    
    func resetElements() {
        filteredElements = elements
        for element in filteredElements {
            element.filteredIsotopes = element.isotopes
        }
        tableView.reloadData()
    }

}
