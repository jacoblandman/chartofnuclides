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
    @IBOutlet weak var halfLifeLbl: UILabel!
    
    var isotope: Isotope!
    
    var viewsToFadeIn: Array<UIView> {
        return []
    }
    
    var largeView: UIView {
        return self.IsotopeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientViewBg.addWhiteShadow()
        gradientViewBg.setValuesForRadialGradient(color1: GREEN_COLOR, color2: UIColor.white,
                                                  relativeCenterPoint: CGPoint(x: 0.5, y: 0.5), innerRadius: 10, outerRadius: gradientViewBg.frame.width)
        gradientViewBg.setNeedsDisplay()
        
        updateUI()
    }
        
    func updateUI() {
        nameLbl.text = "\(isotope.element.symbol)\(isotope.atomicNumber)"
        
        if let mass = isotope.mass.doubleValue {
            massLbl.text = "\(mass.roundedTo(places: 4))"
        }
        
        if isotope.isStable.toBool() {
            if let abundance = isotope.abundance.doubleValue {
                self.halfLifeLbl.text = "\(abundance.roundedTo(places: 6))"
            }
        } else {
            if let halfLife = isotope.halfLife.timeConverted() {
                halfLifeLbl.text = halfLife
            } else {
                halfLifeLbl.text = "\(isotope.halfLife) s"
            }
        }
        
        setBackgroundColor()
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        gradientViewBg.alpha = 1
        dismiss(animated: true, completion: nil)
    }
    
    func setBackgroundColor() {
        if isotope!.isStable.toBool() {
            IsotopeView.backgroundColor = colorWithHexString(hex: "DCDCDC")
        } else {
            IsotopeView.backgroundColor = UIColor.white
        }
    }
    
    
}

