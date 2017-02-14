//
//  RadialGradientView.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/13/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

@IBDesignable
class RadialGradientView: InspectableShadowView {

    @IBInspectable var innerColor: UIColor = UIColor.clear
    @IBInspectable var outerColor: UIColor = UIColor.clear
    @IBInspectable var centerPoint: CGPoint = CGPoint.zero
    @IBInspectable var innerRadius: CGFloat = 0.0
    @IBInspectable var outerRadius: CGFloat = 0.0

    override func draw(_ rect: CGRect) {
        let colors = [innerColor.cgColor, outerColor.cgColor] as CFArray
        
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        
        UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: centerPoint, startRadius: innerRadius, endCenter: centerPoint, endRadius: outerRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
    }
    
    
}
