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
    
    var elements = [Element]()
    var filteredElements = [Element]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.superview?.layer.cornerRadius = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        elements = DataService.instance.parse_json()
        filteredElements = elements
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredElements[section].isotopes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupIsotopeCell", for: indexPath)
        cell.textLabel?.text = "\(filteredElements[indexPath.section].isotopes[indexPath.row].atomicNumber)"
        return cell
    }
}

extension PopupSearchVC: UISearchBarDelegate {
    
}
