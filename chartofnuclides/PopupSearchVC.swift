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
        return filteredElements[section].isotopes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupIsotopeCell", for: indexPath) as! PopupIsotopeCell
        let isotope = filteredElements[indexPath.section].isotopes[indexPath.row]
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
        
        let isotope = filteredElements[indexPath.section].isotopes[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        // send the selected isotope back to the previous view controller
        delegate?.sendDataToA(data: isotope)
        _ = navigationController?.popViewController(animated: true)
    }
}

extension PopupSearchVC: UISearchBarDelegate {

}
