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

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var gradientViewBg: GradientView!
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
        gradientViewBg.alpha = 1
        dismiss(animated: true, completion: nil)
    }
    
    
}

