//
//  LinearGradient.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/14/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

@IBDesignable
class LinearGradient: UIView {

    @IBInspectable var firstColor: UIColor = UIColor.clear
    @IBInspectable var secondColor: UIColor = UIColor.clear
    @IBInspectable var startPoint: CGPoint = CGPoint.zero
    @IBInspectable var endPoint: CGPoint = CGPoint.zero
    
    override func draw(_ rect: CGRect) {
        let colors = [firstColor.cgColor, secondColor.cgColor] as CFArray
        
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        
        UIGraphicsGetCurrentContext()!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.drawsAfterEndLocation)
    }
    
}
