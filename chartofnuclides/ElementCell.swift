//
//  ElementCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ElementCell: UITableViewCell {

    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ElementCell {
    // D type conforms to both the datasource and delegate protocols
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        
        set {
            collectionView.contentOffset.x = newValue
        }
    }
}
    


