//
//  JLWaveNavigationControllerDelegate.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/23/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class JLWaveNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = JLGeneralWaveAnimation()
        animator.animationDuration = 0.35
        
        if operation != UINavigationControllerOperation.push {
            
            
            animator.reversed = true
            return nil
        }
        
        return animator
    }
}
