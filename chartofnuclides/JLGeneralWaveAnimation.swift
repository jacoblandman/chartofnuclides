//
//  JLGeneralWaveAnimation.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/23/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class JLGeneralWaveAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    internal var reversed: Bool = false
    
    internal var animationDuration: Double! = 0.35
    internal let kCellAnimSmallDelta: Double! = 0.01
    internal let kCellAnimBigDelta: Double! = 0.01
    
    typealias fromVCClassType = ConverterVC
    typealias toVCClassType = ConversionVC
    
    fileprivate let kTopCellLayerZIndex: CGFloat! = 1000.0
    fileprivate let kDeltaBetweenCellLayers: Int! = 2
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let container = transitionContext.containerView
        
        container.backgroundColor = UIColor.clear
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        
        if self.reversed == false {
            
            let destinationVC = toVC as! toVCClassType
            let sourceVC = fromVC as! fromVCClassType
            
            container.insertSubview(toVC.view, aboveSubview: fromVC.view)
            //copy colors
            let destinationVCBackgroundColor = (toVC as! toVCClassType).view.backgroundColor
            
            self.viewTransition(toVC, transitionContext: transitionContext, destinationVC: destinationVC, sourceVC: sourceVC, destinationVCBackgroundColor: destinationVCBackgroundColor)
        } else {
            
            let destinationVC = toVC as! fromVCClassType
            let sourceVC = toVC as! toVCClassType
            
            container.insertSubview(toVC.view, belowSubview: fromVC.view)
            
//            self.reversedCollectionViewTransition(toVC, fromVC: fromVC, transitionContext: transitionContext, sourceVC: sourceVC, destinationVC: destinationVC)
        }
    }
    
    //MARK :- helper private methods
    
    fileprivate func viewTransition(_ toVC: UIViewController, transitionContext: UIViewControllerContextTransitioning, destinationVC: toVCClassType, sourceVC: fromVCClassType, destinationVCBackgroundColor: UIColor?) {
        
        setupDestinationViewController(toVC, context: transitionContext)
        
        for view in destinationVC.viewsShownAfterAnimation {
            view.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.0, delay: animationDuration + 0.4, options: [], animations: {
            for view in destinationVC.viewsShownAfterAnimation {
                view.alpha = 1.0
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            //fake empty animation
        }) { (finished) -> Void in
            
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                
                toVC.view.alpha = 1.0
            })
            
            UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                
                toVC.view.alpha = 1.0
                toVC.view.backgroundColor = destinationVCBackgroundColor
                
            }) { (finished) -> Void in
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
            self.addAnimationsToDestinationView(destinationVC, sourceVC: sourceVC, toVC: toVC)
        }
    }
    
    
    fileprivate func calculateSourceAnimationPoint(_ selectedCellCenter: CGPoint, sourceVC: fromVCClassType, destinationVC: toVCClassType) -> CGPoint {
        
        let animateFromPoint = sourceVC.collectionView?.convert(selectedCellCenter, to: destinationVC.view)
        return animateFromPoint!
    }
    
    fileprivate func addAnimationsToDestinationView(_ destinationVC: toVCClassType, sourceVC: fromVCClassType, toVC: UIViewController) {
        
        let indexPaths: NSArray = sourceVC.collectionView!.indexPathsForSelectedItems! as NSArray
        let selectedCellIndex: IndexPath = indexPaths.firstObject as! IndexPath
        let selectedCell = sourceVC.collectionView!.cellForItem(at: selectedCellIndex)!
        
        //copy selected cell background color
        let selectedCellBackgroundColor = selectedCell.backgroundColor
        
        print(selectedCell.center)
        let sourceAnimationPoint = self.calculateSourceAnimationPoint(selectedCell.center, sourceVC: sourceVC, destinationVC: destinationVC)
        
        destinationVC.fromPoint = sourceAnimationPoint
        
        for (index, animatedView) in destinationVC.orderedViewsToBeAnimated.enumerated() {
            self.addViewAnimations(sourceAnimationPoint, sourceVC: sourceVC, destinationVC: destinationVC, animatedView: animatedView, fromCellColor: selectedCellBackgroundColor!, viewIndex: index)
        }
    }
    
    fileprivate func addViewAnimations(_ animateFromPoint: CGPoint, sourceVC: fromVCClassType,
                                       destinationVC: toVCClassType, animatedView: AnyObject,
                                        fromCellColor: UIColor, viewIndex: Int) {
        
        var viewOriginalFrame: CGRect
        var viewOriginalColor: UIColor
        if let view = animatedView as? ConversionButton {
            viewOriginalColor = view.backgroundColor!
            viewOriginalFrame = view.frame
            view.backgroundColor = fromCellColor
            
            let source = sourceVC.collectionView
            
            if let fromFlowLayout = source?.collectionViewLayout as? UICollectionViewFlowLayout {
                
                // the buttons are in superviews, so need to convert the from animation point to the superviews coordinate system
                view.frame.size = fromFlowLayout.itemSize
                view.center = destinationVC.view.convert(animateFromPoint, to: view.superview!)
                view.alpha = 1.0
                view.layer.zPosition = kTopCellLayerZIndex - CGFloat(viewIndex*self.kDeltaBetweenCellLayers)
                view.layoutIfNeeded()
                
                UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: UIViewKeyframeAnimationOptions(), animations: { 
                    var relativeStartTime = (self.kCellAnimBigDelta*Double(viewIndex % 2))
                    
                    var relativeDuration = self.animationDuration - (self.kCellAnimSmallDelta * Double(viewIndex))
                    
                    if (relativeStartTime + relativeDuration) > self.animationDuration {
                        relativeDuration = self.animationDuration - relativeStartTime
                    }
                    
                    relativeStartTime = 0.0
                    relativeDuration = 1.0
                    
                    UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: 0.8, animations: { () -> Void in
                        
                        view.backgroundColor = viewOriginalColor
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: { () -> Void in
                        
                        view.alpha = 1.0
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: 0.8, animations: { () -> Void in
                        
                        view.frame = viewOriginalFrame
                        view.layoutIfNeeded()
                        print("View finsihed frame: ", view.frame)
                    })
                }, completion: { (finished) -> Void in
                    
                    view.layer.zPosition = 0
                })

            }
            
        } else if let view = animatedView as? GradientView {
            viewOriginalColor = view.backgroundColor!
            viewOriginalFrame = view.frame
            view.backgroundColor = fromCellColor
//            view.layer.borderColor = UIColor.black.cgColor
//            view.layer.borderWidth = 1
            
            let source = sourceVC.collectionView
            
            if let fromFlowLayout = source?.collectionViewLayout as? UICollectionViewFlowLayout {
                
                view.frame.size = fromFlowLayout.itemSize
                view.center = animateFromPoint
                view.alpha = 1.0
                view.layer.zPosition = kTopCellLayerZIndex - CGFloat(viewIndex*self.kDeltaBetweenCellLayers)
                view.layoutIfNeeded()
                
                UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: UIViewKeyframeAnimationOptions(), animations: {
                    var relativeStartTime = (self.kCellAnimBigDelta*Double(viewIndex % 1))
                    
                    var relativeDuration = self.animationDuration - (self.kCellAnimSmallDelta * Double(viewIndex))
                    
                    if (relativeStartTime + relativeDuration) > self.animationDuration {
                        relativeDuration = self.animationDuration - relativeStartTime
                    }
                    
                    relativeStartTime = 0.0
                    relativeDuration = 1.0
                    
                    UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: 0.8, animations: { () -> Void in
                        
                        view.backgroundColor = viewOriginalColor
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: { () -> Void in
                        
                        view.alpha = 1.0
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: 0.8, animations: { () -> Void in
                        
                        //cell.frame = self.centerPointWithSizeToFrame(cellLayoutAttributes.center, size: toFlowLayout.itemSize)
                        view.frame = viewOriginalFrame
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.0, animations: { () -> Void in
                        
                        //cell.frame = self.centerPointWithSizeToFrame(cellLayoutAttributes.center, size: toFlowLayout.itemSize)
                        destinationVC.deleteKeyImg.alpha = 1.0
                    })
                    
                }, completion: { (finished) -> Void in
                    
                    view.layer.zPosition = 0
                })
                
            }
        }
    }
    

    
    fileprivate func setupDestinationViewController(_ destinationVC: UIViewController, context: UIViewControllerContextTransitioning) {
        //set clear color
        if let destinationViewController = destinationVC as? toVCClassType {
            destinationViewController.deleteKeyImg.alpha = 0.0
        }
        
        destinationVC.view.backgroundColor = UIColor.clear
        destinationVC.view.alpha = 0.0
        
    }

    
}
