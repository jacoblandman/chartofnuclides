//
//  IsotopeCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class IsotopeCell: UICollectionViewCell {
    
    @IBOutlet weak var spinLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var massLbl: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var halfLifeLbl: UILabel!
    var isotope: Isotope?
    var originalBGColor = UIColor.white
    var triangleLayer: CAShapeLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.addLightShadow()
        shadowView.layer.borderColor = shadowView.colorWithHexString(hex: "B8B8B8").cgColor
        shadowView.layer.borderWidth = 1.0
        shadowView.layer.cornerRadius = 2
    }
    
    func updateCell(isotope: Isotope) {
        
        self.isotope = isotope
        self.nameLbl.text = "\(isotope.element.symbol)\(isotope.atomicNumber)"
        self.spinLbl.text = isotope.spin
        
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
        
        if let mass = isotope.mass.doubleValue {
            self.massLbl.text = "\(mass.roundedTo(places: 4))"
        }
        
        if let fissionYield = isotope.indFissionYield.doubleValue, fissionYield != 0.0 {
            let triangleColor = self.determineFissionYieldColor(yield: fissionYield)
            drawTriangle(with: triangleColor)
            
        } else {
            // remove previous triangle layer
            if triangleLayer != nil {
                removeTriangleLayer()
                triangleLayer = nil
            }
        }
        
        
        setBackgroundColor()
        
    }
    
    func removeTriangleLayer() {
        if let sublayer = shadowView.layer.sublayers {
            for layer in sublayer {
                if layer.name == "triangle" {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func setBackgroundColor() {
        if isotope!.isStable.toBool() {
            shadowView.backgroundColor = colorWithHexString(hex: "DCDCDC")
        } else {
            shadowView.backgroundColor = UIColor.white
        }
    }
    
    func highlight() {
        
        originalBGColor = shadowView.backgroundColor!
        shadowView.backgroundColor = UIColor.darkGray
        shadowView.alpha = 0.5
    }
    
    func unhighlight() {
        
        shadowView.backgroundColor = originalBGColor
        shadowView.alpha = 1.0
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
        trianglePath.addLine(to: CGPoint(x: 0, y: -shadowView.frame.height / 8))
        trianglePath.addLine(to: CGPoint(x: -shadowView.frame.width / 8, y: 0))
        trianglePath.close()
        
        triangleLayer!.path = trianglePath.cgPath
        triangleLayer!.fillColor = color.cgColor
        triangleLayer!.anchorPoint = .zero
        triangleLayer!.position = CGPoint(x: shadowView.frame.width, y: shadowView.frame.height)
        triangleLayer!.name = "triangle"
        shadowView.layer.addSublayer(triangleLayer!)
        
    }
}
