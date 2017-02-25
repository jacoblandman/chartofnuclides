//
//  DetailNuclideVC.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/14/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class DetailNuclideVC: UIViewController, MZMaskZoomTransitionPresentedViewController, UINavigationControllerDelegate {

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var gradientViewBg: GradientView!
    @IBOutlet weak var IsotopeView: InspectableBorderView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var massLbl: UILabel!
    
    var isotope: Isotope!
    
    var viewsToFadeIn: Array<UIView> {
        return []
    }
    
    var largeView: UIView {
        return self.IsotopeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientViewBg.setValuesForLinearGradient(color1: UIColor.white, color2: GREEN_COLOR, relativeStartPoint: CGPoint(x: 0, y: 0.5), relativeEndPoint: CGPoint(x: 1, y: 0.5))
        gradientViewBg.setNeedsDisplay()
        
        updateUI()
    }
        
    func updateUI() {
        nameLbl.text = "\(isotope.element.symbol)\(isotope.atomicNumber)"
        
        if let mass = isotope.mass.doubleValue {
            massLbl.text = "\(mass.roundedTo(places: 4))"
        }
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        gradientViewBg.alpha = 1
        dismiss(animated: true, completion: nil)
    }
    
    
}

