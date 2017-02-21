//
//  ConverterCalcVCTest.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import LeoMaskAnimationKit

class ConverterCalcVCTest: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var mask: UIView!
    @IBOutlet weak var XView: LinearGradient!
    @IBOutlet weak var greyBg: UIView!
    @IBOutlet weak var whiteBg: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setLayoutFor(collectionView, with: view.frame.size)
    }
    
    func setLayoutFor(_ collectionView: UICollectionView, with size: CGSize) {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConverterCalcCell", for: indexPath) as! ConverterCalcCellTest
        cell.update(with: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize(for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ConverterCalcCellTest {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                cell.highlight()
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ConverterCalcCellTest {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                cell.unhighlight()
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 2 {
                animateXView()
            }
        }
    }
    
    
    func cellSize(for indexPath: IndexPath) -> CGSize {
        // 64 is nav and status bar height?
        let height = view.frame.height
        let width = view.frame.width
        let spacing: CGFloat = 1
        
        if indexPath.section == 0 {
            
            let cellHeight = (0.45*height - 2 * spacing) / 2
            if indexPath.row == 0 || indexPath.row == 2 {
                let cellWidth = (width - 2 * spacing) / 3
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
    
    func animateXView() {
        // a nice animation for the done button
        XView.leo_animateCircleExpand(from: mask, duration: 0.5, delay: 0.0, alpha: 1.0, options: LeoMaskAnimationOptions.easeIn, compeletion: nil)
        UIView.animate(withDuration: 0.0) {
            self.XView.alpha = 1.0
        }
    }
}
