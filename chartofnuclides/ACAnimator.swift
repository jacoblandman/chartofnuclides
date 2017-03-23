//
//  ACAnimator.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/22/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

enum TransitionType {
    case presenting, dismissing
}

class ACAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval
    var isPresenting: Bool
    var respondingTextView: UITextView?
    
    init(withDuration duration: TimeInterval, forTransitionType type: TransitionType, respondingTextView: UITextView?) {
        self.duration = duration
        self.isPresenting = type == .presenting
        self.respondingTextView = respondingTextView
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        if isPresenting {
            let destinationVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! CustomAC
            containerView.addSubview(destinationVC.view)
            destinationVC.view.alpha = 0.0
            destinationVC.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            let duration = transitionDuration(using: transitionContext)
            
            UIView.animate(withDuration: duration, animations: { 
                destinationVC.view.alpha = 1.0
                destinationVC.view.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                let cancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancelled)
            })
        } else {
            
            if respondingTextView != nil {
                respondingTextView!.becomeFirstResponder()
            }
            
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! CustomAC
            UIView.animate(withDuration: duration, animations: { 
                fromVC.view.alpha = 0.0
            }, completion: { (finished) in
                let cancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancelled)
            })
        }
        
    }
}
