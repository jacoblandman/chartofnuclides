//
//  DetailNuclideVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/14/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
import LeoMaskAnimationKit

class DetailNuclideVC: UIViewController, MZMaskZoomTransitionPresentedViewController, UINavigationControllerDelegate {

    @IBOutlet weak var gradientView: LinearGradient!
    @IBOutlet weak var mask: InspectableBorderView!
    @IBOutlet weak var IsotopeView: InspectableBorderView!
    @IBOutlet weak var nameLbl: UILabel!
    var isotope: Isotope!
    
    var viewsToFadeIn: Array<UIView> {
        return []
    }
    
    var largeView: UIView {
        return self.IsotopeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradientView.alpha = 1.0
        updateUI()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        // a nice animation for the done button
//        gradientView.leo_animateCircleExpand(from: mask, duration: 1.0, delay: 0.0, alpha: 1.0, options: LeoMaskAnimationOptions.default, compeletion: nil)
//        UIView.animate(withDuration: 0.6) {
//            self.gradientView.alpha = 1.0
//        }
    }
    
    func updateUI() {
        nameLbl.text = "\(isotope.element.symbol)\(isotope.atomicNumber)"
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        self.gradientView.alpha = 0.0
        dismiss(animated: true, completion: nil)
    }
    
}
