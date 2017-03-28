//
//  FadeInTransitionDelegate.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/27/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class FadeInTransitionDelegate: NSObject {

}

extension FadeInTransitionDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInAnimator()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInAnimator()
    }
}
