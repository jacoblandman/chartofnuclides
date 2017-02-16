//
//  ConverterCalcVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/15/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ConverterCalcVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutFor(collectionView!, with: view.frame.size)
    }
    
    func setLayoutFor(_ collectionView: UICollectionView, with size: CGSize) {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
    }
        
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 12
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConverterCalcCell", for: indexPath) as! ConverterCalcCell
        cell.update(with: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize(for: indexPath)
    }
    
    func cellSize(for indexPath: IndexPath) -> CGSize {
        // 64 is nav and status bar height?
        let height = view.frame.height
        let width = view.frame.width
        let spacing: CGFloat = 1
        
        if indexPath.section == 0 {
            
            let cellHeight = (0.45*height - 2 * spacing) / 2
            if indexPath.row == 0 || indexPath.row == 2 {
                let cellWidth = (width - 1 * spacing) / 3
                return CGSize(width: cellWidth, height: cellHeight)
            } else {
                let cellWidth = 2 * (width - 1 * spacing) / 3
                return CGSize(width: cellWidth, height: cellHeight)
            }
            
        } else {
            let cellHeight = (0.55*height - 4 * spacing) / 4
            let cellWidth = (width - 3 * spacing) / 3
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    

    


}
