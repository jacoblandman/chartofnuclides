//
//  ConverterVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/14/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ConverterVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //var unitTypes = [
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutFor(collectionView!, with: collectionView!.frame.size)
        
    }
    
    func setLayoutFor(_ collectionView: UICollectionView, with size: CGSize) {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        setItemSize(for: layout, with: size)
        collectionView.collectionViewLayout = layout
    }
    
    func setItemSize(for layout: UICollectionViewFlowLayout, with size: CGSize) {
        
        let viewWidth = view.frame.width
        print("JACOB: The view widht is \(viewWidth)")
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.itemSize = CGSize(width: (viewWidth - 2 * layout.minimumInteritemSpacing) / 3  , height: (viewWidth - 2 * layout.minimumInteritemSpacing) / 3 )
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.instance.unitTypes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnitCell", for: indexPath) as! ConversionUnitCell
        cell.updateCell(unitName: DataService.instance.unitTypes[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        performSegue(withIdentifier: "ConverterCalcVC", sender: nil)
    }
    

}
