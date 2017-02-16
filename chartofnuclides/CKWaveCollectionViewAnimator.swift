//
//  CKWaveCollectionViewAnimator.swift
//  CKWaveCollectionViewTransition
//
//  Created by Salvation on 7/13/15.
//  salvation.sv@gmail.com
//  cezarykopacz.github.io
//  Copyright (c) 2015 CezaryKopacz. All rights reserved.
//

import UIKit

class CKWaveCollectionViewAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    internal var reversed: Bool = false
    
    internal var animationDuration: Double! = 1.0
    internal let kCellAnimSmallDelta: Double! = 0.01
    internal let kCellAnimBigDelta: Double! = 0.01
    
    
    fileprivate let kTopCellLayerZIndex: CGFloat! = 1000.0
    fileprivate let kDeltaBetweenCellLayers: Int! = 2
    
    //MARK :- UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        var destinationCollectionViewController: UICollectionViewController!
        var sourceCollectionViewController: UICollectionViewController!
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let container = transitionContext.containerView
        
        container.backgroundColor = UIColor.clear

        destinationCollectionViewController = toViewController as? UICollectionViewController
        assert(destinationCollectionViewController != nil, "Destination view controller is not a UICollectionViewController subclass!")
        
        sourceCollectionViewController = fromViewController as? UICollectionViewController
        assert(sourceCollectionViewController != nil, "Source view controller is not a UICollectionViewController subclass!")
        
        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        
        if self.reversed == false {
        
            container.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
            //copy colors
            let destinationViewControllerViewBackgroundColor = toViewController.view.backgroundColor
            let destinationCollectionViewBackgroundColor = destinationCollectionViewController.collectionView?.backgroundColor

            self.collectionViewTransition(toViewController, transitionContext: transitionContext, destinationCollectionViewController: destinationCollectionViewController, sourceCollectionViewController: sourceCollectionViewController, destinationViewControllerViewBackgroundColor: destinationViewControllerViewBackgroundColor, destinationCollectionViewBackgroundColor: destinationCollectionViewBackgroundColor)
        } else {
        
            container.insertSubview(toViewController.view, belowSubview: fromViewController.view)

            self.reversedCollectionViewTransition(toViewController, fromViewController: fromViewController, transitionContext: transitionContext, sourceCollectionViewController: sourceCollectionViewController, destinationCollectionViewController: destinationCollectionViewController)
        }
    }

    //MARK :- helper private methods
    
    fileprivate func collectionViewTransition(_ toViewController: UIViewController, transitionContext: UIViewControllerContextTransitioning, destinationCollectionViewController: UICollectionViewController, sourceCollectionViewController: UICollectionViewController, destinationViewControllerViewBackgroundColor: UIColor?, destinationCollectionViewBackgroundColor: UIColor?) {
        
        setupDestinationViewController(toViewController, context: transitionContext)
        
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            //fake empty animation
            }) { (finished) -> Void in
                
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    
                    toViewController.view.alpha = 1.0
                    //sourceCollectionViewController.view.alpha = 0.0
                })
                
                UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    
                    //toViewController.view.alpha = 1.0
                    toViewController.view.backgroundColor = destinationViewControllerViewBackgroundColor
                    
                    destinationCollectionViewController.collectionView?.backgroundColor = destinationCollectionViewBackgroundColor
                    
                    }) { (finished) -> Void in
                        
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
                
                self.addAnimationsToDestinationCollectionView(destinationCollectionViewController, sourceCollectionViewController: sourceCollectionViewController, toViewController: toViewController)
        }
    }
    
    fileprivate func reversedCollectionViewTransition(_ toViewController: UIViewController, fromViewController: UIViewController, transitionContext: UIViewControllerContextTransitioning, sourceCollectionViewController: UICollectionViewController, destinationCollectionViewController: UICollectionViewController)
    {
        
        UIView.animate(withDuration: self.animationDuration, delay: self.animationDuration, options: UIViewAnimationOptions.curveEaseIn, animations: {
            fromViewController.view.alpha = 0.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            //fake empty animation
            }) { (finished) -> Void in
                
                UIView.animate(withDuration: self.animationDuration, animations: { () -> Void in
                    
                    
                    fromViewController.view.backgroundColor = UIColor.clear
                    sourceCollectionViewController.collectionView!.backgroundColor = UIColor.clear
                    
                    }, completion: { (finished) -> Void in
                        
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
                
                let destinationPoint = self.calculateDestinationAnimationPoint(sourceCollectionViewController, toViewController: toViewController)
                
                self.setNewFrameToCells(destinationCollectionViewController)
                self.enumerateVisibleCellsAndAddAnimations(destinationPoint, sourceCollectionViewController: sourceCollectionViewController, destinationCollectionViewController: destinationCollectionViewController)
        }
    }
    
    fileprivate func calculateSourceAnimationPoint(_ selectedCellCenter: CGPoint, sourceCollectionViewController: UICollectionViewController, destinationCollectionViewController: UICollectionViewController) -> CGPoint {
        
        let animateFromPoint = sourceCollectionViewController.collectionView?.convert(selectedCellCenter, to: sourceCollectionViewController.view)
        return CGPoint(x: animateFromPoint!.x,
                           y: animateFromPoint!.y - UIApplication.statusBarHeight() - destinationCollectionViewController.navigationBarHeight())
    }

    fileprivate func addAnimationsToDestinationCollectionView(_ destinationCollectionViewController: UICollectionViewController, sourceCollectionViewController: UICollectionViewController, toViewController: UIViewController) {
        
        let indexPaths: NSArray = sourceCollectionViewController.collectionView!.indexPathsForSelectedItems! as NSArray
        let selectedCellIndex: IndexPath = indexPaths.firstObject as! IndexPath
        let selectedCell = sourceCollectionViewController.collectionView!.cellForItem(at: selectedCellIndex)!
        
        //copy selected cell background color
        let selectedCellBackgroundColor = selectedCell.backgroundColor
        
        let sourceAnimationPoint = self.calculateSourceAnimationPoint(selectedCell.center, sourceCollectionViewController: sourceCollectionViewController, destinationCollectionViewController: destinationCollectionViewController)
        
        destinationCollectionViewController.fromPoint = sourceAnimationPoint
        
        let rowsAndColumns = destinationCollectionViewController.collectionView!.numberOfVisibleRowsAndColumn()
        
        if let indexPathsForVisibleCells = destinationCollectionViewController.collectionView?.indexPathsForVisibleItems {

            let indexPaths = indexPathsForVisibleCells.sorted(by: { (ip1, ip2) -> Bool in
                ip1.row < ip2.row
            })
        
            for (_, index) in indexPaths.enumerated() {
            
                if let cell = destinationCollectionViewController.collectionView?.cellForItem(at: IndexPath(row: (index as NSIndexPath).row, section: (index as NSIndexPath).section)) {
                    
                    self.addCellAnimations(sourceAnimationPoint, sourceCollectionViewController: sourceCollectionViewController, destinationCollectionViewController: destinationCollectionViewController, cell: cell, fromCellColor: selectedCellBackgroundColor!, cellIndexPath: index, rowsAndColumns: rowsAndColumns)
                }
            }

        }
    }
    
    fileprivate func addCellAnimations(_ animateFromPoint: CGPoint, sourceCollectionViewController: UICollectionViewController, destinationCollectionViewController: UICollectionViewController, cell: UICollectionViewCell, fromCellColor: UIColor, cellIndexPath: IndexPath, rowsAndColumns: (rows: Int, columns: Int)) {
        
        //copy cell color
        //temporary change cell color to selected cell background color
        var cellOriginalColor: UIColor!
        if let cell = cell as? ConverterCalcCell {
            cellOriginalColor = cell.bgView.backgroundColor
            cell.bgView.backgroundColor = fromCellColor
        } else {
            cellOriginalColor = cell.backgroundColor
            cell.backgroundColor = fromCellColor
        }
        
        let source = sourceCollectionViewController.collectionView
        let destinationVC = destinationCollectionViewController as! ConverterCalcVC
        let destination = destinationCollectionViewController.collectionView
        
        if let fromFlowLayout = source?.collectionViewLayout as? UICollectionViewFlowLayout,
            let _ = destination?.collectionViewLayout as? UICollectionViewFlowLayout,
            let cellLayoutAttributes = destination?.layoutAttributesForItem(at: cellIndexPath) {

            cell.frame.size = fromFlowLayout.itemSize
            cell.center = animateFromPoint
            cell.alpha = 1.0
            cell.layer.zPosition = kTopCellLayerZIndex - CGFloat((cellIndexPath as NSIndexPath).row*self.kDeltaBetweenCellLayers)
        
            UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: { () -> Void in
            
                let relativeStartTime = (self.kCellAnimBigDelta*Double((cellIndexPath as NSIndexPath).row % rowsAndColumns.columns))

                var relativeDuration = self.animationDuration - (self.kCellAnimSmallDelta * Double((cellIndexPath as NSIndexPath).row))
            
                if (relativeStartTime + relativeDuration) > self.animationDuration {
                    relativeDuration = self.animationDuration - relativeStartTime
                }
            
                UIView.addKeyframe(withRelativeStartTime: 0.0 + (self.kCellAnimBigDelta*Double((cellIndexPath as NSIndexPath).row % rowsAndColumns.columns)), relativeDuration: relativeDuration, animations: { () -> Void in
                
                    if let cell = cell as? ConverterCalcCell {
                        cell.bgView.backgroundColor = cellOriginalColor
                    } else {
                        cell.backgroundColor = cellOriginalColor
                    }
                })
            
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: { () -> Void in
                
                    cell.alpha = 1.0
                })
            
                UIView.addKeyframe(withRelativeStartTime: 0.0 + (self.kCellAnimBigDelta*Double((cellIndexPath as NSIndexPath).row % rowsAndColumns.columns)), relativeDuration: relativeDuration, animations: { () -> Void in
                
                    //cell.frame = self.centerPointWithSizeToFrame(cellLayoutAttributes.center, size: toFlowLayout.itemSize)
                    cell.frame = self.centerPointWithSizeToFrame(cellLayoutAttributes.center, size: destinationVC.cellSize(for: cellIndexPath))
                })
            
                }, completion: { (finished) -> Void in
                
                    cell.layer.zPosition = 0
            })
        }
    }
    
    fileprivate func calculateDestinationAnimationPoint(_ sourceCollectionViewController: UICollectionViewController, toViewController: UIViewController) -> CGPoint {
    
        let animateToPoint = sourceCollectionViewController.fromPoint
        let offset = sourceCollectionViewController.collectionView!.contentOffset.y

        return CGPoint(x: animateToPoint!.x,
                           y: animateToPoint!.y + offset + toViewController.navigationBarHeight() + UIApplication.statusBarHeight())
    }
    
    fileprivate func setNewFrameToCells(_ destinationCollectionViewController: UICollectionViewController) {
        
        if let destinationIndexPathsForVisibleCells = destinationCollectionViewController.collectionView?.indexPathsForVisibleItems {

            let sortedIndexPaths = destinationIndexPathsForVisibleCells.sorted(by: { (ip1, ip2) -> Bool in
                ip1.row < ip2.row
            })
            
            for (_, index) in sortedIndexPaths.enumerated() {
           
                if let cell = destinationCollectionViewController.collectionView?.cellForItem(at: index),
                
                    let layoutAttributes = destinationCollectionViewController.collectionView?.layoutAttributesForItem(at: index) {
        
                        cell.frame = layoutAttributes.frame
                }
            }
        }
    }
    
    fileprivate func enumerateVisibleCellsAndAddAnimations(_ destinationPoint: CGPoint, sourceCollectionViewController: UICollectionViewController, destinationCollectionViewController: UICollectionViewController) {

        assert(destinationCollectionViewController.selectedIndexPath != nil, "Forgot to set selectedIndexPath property?")
        
        var sourceIndexPathsForVisibleCells = sourceCollectionViewController.collectionView?.indexPathsForVisibleItems
        sourceIndexPathsForVisibleCells = sourceIndexPathsForVisibleCells?.sorted(by: { (ip1, ip2) -> Bool in
            ip1.row < ip2.row
        })
        
        sourceIndexPathsForVisibleCells = sourceIndexPathsForVisibleCells?.sorted(by: { (ip1, ip2) -> Bool in
            ip1.section < ip2.section
        })
        
        let rowsAndColumns = destinationCollectionViewController.collectionView!.numberOfVisibleRowsAndColumn()
        
        for (idx, index) in sourceIndexPathsForVisibleCells!.reversed().enumerated() {

            if let cell = sourceCollectionViewController.collectionView?.cellForItem(at: index),
                let _ = sourceCollectionViewController.collectionView?.layoutAttributesForItem(at: index),
                let lastSelectedCell = destinationCollectionViewController.collectionView?.cellForItem(at: destinationCollectionViewController.selectedIndexPath as IndexPath),
                let flowLayout = destinationCollectionViewController.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                
                    let fromCellSize = (sourceCollectionViewController as! ConverterCalcVC).cellSize(for: index)
                    cell.layer.zPosition = kTopCellLayerZIndex - CGFloat(idx*self.kDeltaBetweenCellLayers)

                    self.addCellReversedAnimations(destinationPoint, cell: cell, cellIndex: idx, toCellSize: flowLayout.itemSize, fromCellSize: fromCellSize, cellBackgroundColor: lastSelectedCell.backgroundColor!, rowsAndColumns: rowsAndColumns, indexPath: index)
            }
        }
    }
    
    fileprivate func setupDestinationViewController(_ destinationVC: UIViewController, context: UIViewControllerContextTransitioning) {
        //set clear color
        if let destinationCollectionViewController = destinationVC as? UICollectionViewController {
             destinationCollectionViewController.collectionView?.backgroundColor = UIColor.clear
        }
        
        destinationVC.view.backgroundColor = UIColor.clear
        destinationVC.view.alpha = 0.0
    }

    fileprivate func addCellReversedAnimations(_ animateToPoint: CGPoint, cell: UICollectionViewCell, cellIndex: Int, toCellSize: CGSize, fromCellSize: CGSize, cellBackgroundColor: UIColor, rowsAndColumns: (rows: Int, columns: Int), indexPath: IndexPath) {

        
        let relativeStartTime = self.kCellAnimBigDelta * Double(cellIndex % rowsAndColumns.columns)
        var relativeDuration = self.animationDuration - (self.kCellAnimSmallDelta * Double(cellIndex))
        
        if (relativeStartTime + relativeDuration) > self.animationDuration {
            relativeDuration = self.animationDuration - relativeStartTime
        }
        
        UIView.animateKeyframes(withDuration: self.animationDuration, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: { () -> Void in
            
            UIView.addKeyframe(withRelativeStartTime: 0.0 + (self.kCellAnimSmallDelta * Double(cellIndex)), relativeDuration: relativeDuration, animations: { () -> Void in
                
                if let cell = cell as? ConverterCalcCell {
                    cell.bgView.backgroundColor = UIColor.clear
                    cell.mainLbl.alpha = 0.0
                }
                
                cell.backgroundColor = UIColor.clear
            })
            
            UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: relativeDuration, animations: { () -> Void in

                let cell = cell as! ConverterCalcCell
                let newFrame = self.centerPointWithSizeToFrame(animateToPoint, size: toCellSize)
                cell.frame = self.centerPointWithSizeToFrame(animateToPoint, size: toCellSize)
                cell.contentView.frame = CGRect(x: 0, y: 0, width: newFrame.width, height: newFrame.height)
                cell.layoutIfNeeded()
            })
            
            }, completion: { (finished) -> Void in
                
                cell.layer.zPosition = 0
        })
    }
    
    fileprivate func centerPointWithSizeToFrame(_ point: CGPoint, size: CGSize) -> CGRect {
        return CGRect(x: point.x - (size.width/2), y: point.y - (size.height/2), width: size.width, height: size.height)
    }
    
    //MARK :- UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}