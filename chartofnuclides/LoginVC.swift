//
//  LoginVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/27/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UIViewControllerTransitioningDelegate {

    let fadeInTransitionAnimator = FadeInAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func emailLoginPressed(_ sender: Any) {
        performSegue(withIdentifier: "EmailLoginVC", sender: nil)
    }

    @IBAction func facebookLoginPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EmailLoginVC" {
            if let destination = segue.destination as? EmailLoginVC {
                destination.transitioningDelegate = self
            }
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fadeInTransitionAnimator.animationDuration = 0.7
        return fadeInTransitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return fadeInTransitionAnimator
    }

    @IBAction func xPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
