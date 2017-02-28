//
//  File.swift
//  Transition
//
//  Created by Jacob Landman on 2/21/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class FadeInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var _animationDuration: Double = 0.35
    
    var animationDuration: Double {
        set {
            _animationDuration = newValue
        }
        get {
            return _animationDuration
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return _animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        containerView.addSubview(toVC!.view)
        toVC!.view.alpha = 0.0
        
        // this line is needed to set the correct top layout guide for auto constraints
        // the final frame has the correct value
        toVC!.view.frame = transitionContext.finalFrame(for: toVC!)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            toVC!.view.alpha = 1.0
        }) { (finished) in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        }
        
    }
}
