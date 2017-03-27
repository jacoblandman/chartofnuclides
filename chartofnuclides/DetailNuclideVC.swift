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
    @IBOutlet weak var crossSectionLbl: UILabel!
    @IBOutlet weak var bottomBgView: UIView!
    @IBOutlet weak var topBgView: UIView!
    @IBOutlet weak var containerView: UIView!
    
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
        containerView.layer.cornerRadius = 4
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
        
        if let fissionYield = isotope.indFissionYield.doubleValue, fissionYield != 0.0 {
            let triangleColor = self.determineFissionYieldColor(yield: fissionYield)
            drawTriangle(with: triangleColor)
        }
        
        if !isotope.crossSection.isEmpty {
            let crossSection = NSMutableAttributedString(string: "    \(isotope.crossSection) b")
            let sigma = "σ".subscriptString(with: "a", regularSize: 17.5)
            sigma.append(crossSection)
            crossSectionLbl.attributedText = sigma
        } else {
            crossSectionLbl.text = ""
        }
        
        setBackgroundColors(halfLife: isotope.halfLife, crossSection: isotope.crossSection)
    }
    
    func setTopColor(halfLife: String) {
        if let halfLife = halfLife.doubleValue {
            if halfLife < 1.57788e16 {
                if halfLife > 3.154e+8 {
                    topBgView.backgroundColor = COLOR_ISOTOPE_BLUE
                } else if halfLife > 8.64e+6 {
                    topBgView.backgroundColor = COLOR_ISOTOPE_GREEN
                } else if halfLife > 864000 {
                    topBgView.backgroundColor = COLOR_ISOTOPE_YELLOW
                } else if halfLife > 86400 {
                    topBgView.backgroundColor = COLOR_ISOTOPE_ORANGE
                } else {
                    topBgView.backgroundColor = UIColor.clear
                }
            } else {
                topBgView.backgroundColor = UIColor.clear
            }
        } else {
            topBgView.backgroundColor = UIColor.clear
        }
    }
    
    func setBottomColor(crossSection: String) {
        
        if !crossSection.isEmpty {
            var strippedCrossSection = crossSection
            strippedCrossSection.stripUncertainty()
            if let crossSection = strippedCrossSection.doubleValue {
                if crossSection > 1000 {
                    bottomBgView.backgroundColor = COLOR_ISOTOPE_ORANGE
                } else if crossSection > 500 {
                    bottomBgView.backgroundColor = COLOR_ISOTOPE_YELLOW
                } else if crossSection > 100 {
                    bottomBgView.backgroundColor = COLOR_ISOTOPE_GREEN
                } else if crossSection > 10 {
                    bottomBgView.backgroundColor = COLOR_ISOTOPE_BLUE
                } else {
                    bottomBgView.backgroundColor = UIColor.clear
                }
            } else {
                bottomBgView.backgroundColor = UIColor.clear
            }
        } else {
            bottomBgView.backgroundColor = UIColor.clear
        }
    }

    
    
    @IBAction func donePressed(_ sender: Any) {
        gradientViewBg.alpha = 1
        dismiss(animated: true, completion: nil)
    }
    
    func setBackgroundColors(halfLife: String, crossSection: String) {
        if isotope!.isStable.toBool() {
            IsotopeView.backgroundColor = colorWithHexString(hex: "DCDCDC")
        } else {
            IsotopeView.backgroundColor = UIColor.white
        }
        
        setTopColor(halfLife: halfLife)
        setBottomColor(crossSection: crossSection)
    }
    
    func determineFissionYieldColor(yield: Double) -> UIColor {
        
        let percentYield = yield * 100
        if percentYield > 3 {
            return COLOR_ISOTOPE_ORANGE
        } else if percentYield > 1 {
            return COLOR_ISOTOPE_YELLOW
        } else if percentYield > 0.1 {
            return COLOR_ISOTOPE_GREEN
        } else if percentYield > 0.01 {
            return COLOR_ISOTOPE_BLUE
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
        triangleLayer!.strokeColor = UIColor.darkGray.cgColor
        triangleLayer!.lineWidth = 0.5
        triangleLayer!.position = CGPoint(x: IsotopeView.frame.width, y: IsotopeView.frame.height)
        triangleLayer!.name = "triangle"
        containerView.layer.addSublayer(triangleLayer!)
        
    }
    
}

