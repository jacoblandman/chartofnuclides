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
    @IBOutlet weak var spinLbl: UILabel!
    
    var triangleLayer: CAShapeLayer?
    
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
        spinLbl.text = isotope.spin
        
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
        
        if let fissionYield = isotope.indFissionYield.doubleValue {
            let triangleColor = self.determineFissionYieldColor(yield: fissionYield)
            drawTriangle(with: triangleColor)
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
    
    func determineFissionYieldColor(yield: Double) -> UIColor {
        
        let percentYield = yield * 100
        if percentYield > 3 {
            return COLOR_FISSIONYIELD_ORANGE
        } else if percentYield > 1 {
            return COLOR_FISSIONYIELD_YELLOW
        } else if percentYield > 0.1 {
            return COLOR_FISSIONYIELD_GREEN
        } else if percentYield > 0.01 {
            return COLOR_FISSIONYIELD_BLUE
        } else if percentYield > 2.5E-6 {
            return UIColor.darkGray
        } else {
            return UIColor.white
        }
    }
    
    func drawTriangle(with color: UIColor) {
        
        triangleLayer = CAShapeLayer()
        let trianglePath = UIBezierPath()
        trianglePath.move(to: .zero)
        trianglePath.addLine(to: CGPoint(x: 0, y: -IsotopeView.frame.height / 8))
        trianglePath.addLine(to: CGPoint(x: -IsotopeView.frame.width / 8, y: 0))
        trianglePath.close()
        
        triangleLayer!.path = trianglePath.cgPath
        triangleLayer!.fillColor = color.cgColor
        triangleLayer!.anchorPoint = .zero
        triangleLayer!.position = CGPoint(x: IsotopeView.frame.width, y: IsotopeView.frame.height)
        triangleLayer!.name = "triangle"
        IsotopeView.layer.addSublayer(triangleLayer!)
        
    }
    
}

