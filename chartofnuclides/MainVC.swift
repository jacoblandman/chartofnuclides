//
//  MainVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/2/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var elements = [Element]()
    var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        elements = DataService.instance.parse_json()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(elements.count)")
        return elements.count
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
        
        return elements[collectionView.tag].isotopes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IsotopeCell", for: indexPath) as? IsotopeCell {
            let isotope = elements[collectionView.tag].isotopes[indexPath.row]
            cell.updateCell(isotope: isotope)
            return cell
        } else {
            print("JACOB: Returning a regular collection view cell")
            return UICollectionViewCell()
        }
    }
    
}

