//
//  ConverterCalcVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ConverterCalcVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var tableViewBg: UIView!
    @IBOutlet weak var tableViewMask: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mask: UIView!
    @IBOutlet weak var XView: GradientView!
    @IBOutlet weak var greyBg: UIView!
    @IBOutlet weak var whiteBg: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var triangleLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setLayoutFor(collectionView, with: view.frame.size)
        XView.setValuesForLinearGradient(color1: UIColor.white, color2: GREEN_COLOR, startPoint: CGPoint(x: XView.frame.width / 2, y: 0.0), endPoint: CGPoint(x: XView.frame.width / 2, y: XView.frame.height / 2))
        XView.setNeedsDisplay()

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConverterCalcCell", for: indexPath) as! ConverterCalcCell
        cell.update(with: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize(for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ConverterCalcCell {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                cell.highlight()
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ConverterCalcCell {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                cell.unhighlight()
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 2 {
                let cellFrame = (collectionView.cellForItem(at: indexPath) as! ConverterCalcCell).frame
                animateXView()
                let size: CGFloat = 10
                createTriangle(size: 10, x: cellFrame.maxX - size + 1, y: cellFrame.midY)
                ////createPopover(fromCell: collectionView.cellForItem(at: indexPath) as! ConverterCalcCell)
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
        if XView.alpha != 1.0 {
            XView.leo_animateCircleExpand(from: mask, duration: 0.35, delay: 0.0, alpha: 1.0, options: LeoMaskAnimationOptions.easeIn, compeletion: nil)
            
            tableViewBg.leo_animateCircleExpand(from: tableViewMask, duration: 0.5, delay: 0.0, alpha: 1.0, options:LeoMaskAnimationOptions.easeIn, compeletion: nil)
            UIView.animate(withDuration: 0.0) {
                self.XView.alpha = 1.0
                self.tableViewBg.alpha = 1.0
            }
        }
    }
    
    func createTriangle(size: CGFloat, x: CGFloat, y: CGFloat) {
        // create an arrow that points to the left
        
        if let triangle = triangleLayer {
            triangle.position = CGPoint(x: x ,y: y)
        } else {
            triangleLayer = CAShapeLayer()
            let trianglePath = UIBezierPath()
            trianglePath.move(to: .zero)
            trianglePath.addLine(to: CGPoint(x: size, y: size))
            trianglePath.addLine(to: CGPoint(x: size, y: -size))
            trianglePath.close()
            
            triangleLayer!.path = trianglePath.cgPath
            triangleLayer!.fillColor = UIColor.white.cgColor
            triangleLayer!.anchorPoint = .zero
            triangleLayer!.position = CGPoint(x: x ,y: y)
            triangleLayer!.name = "triangle"
            view.layer.addSublayer(triangleLayer!)
        }
    }
    
    @IBAction func XBtnPressed(_ sender: Any) {
        
        XView.leo_removeMaskAnimations()
        XView.leo_animateReverseCircleExpand(to: mask, duration: 0.5, delay: 0.0, alpha: 0.0, options: LeoMaskAnimationOptions.easeOut, completion: nil)
        tableViewBg.leo_animateReverseCircleExpand(to: tableViewMask, duration: 0.5, delay: 0.0, alpha: 0.0, options: LeoMaskAnimationOptions.easeOut, completion: nil)
        
        
        UIView.animate(withDuration: 0.0, delay: 0.5, options: [], animations: { 
            self.XView.alpha = 0.0
            self.tableViewBg.alpha = 0.0
            self.triangleLayer?.removeFromSuperlayer()
            self.triangleLayer = nil
        }, completion: nil)
        
        //mask.leo_animateCircleExpand(from: XView, duration: 0.5, delay: 0.0, alpha: 0.0, options: LeoMaskAnimationOptions.easeIn, compeletion: nil)
        //tableViewBg.leo_removeMaskAnimations()
    }
    

}

extension ConverterCalcVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
