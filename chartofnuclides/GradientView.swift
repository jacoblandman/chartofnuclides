//
//  GradientView.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class GradientView: UIView {

    var firstColor: UIColor = UIColor.clear
    var secondColor: UIColor = UIColor.clear
    
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    
    var centerPoint: CGPoint?
    var innerRadius: CGFloat?
    var outerRadius: CGFloat?
    
    var drawLinear: Bool = false
    var drawRadial: Bool = false
    
//    override class var layerClass: AnyClass {
//        return CAGradientLayer.self
//    }
    
    func setValuesForLinearGradient(color1: UIColor, color2: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        firstColor = color1
        secondColor = color2
        
        self.startPoint = startPoint
        self.endPoint = endPoint
        
        drawLinear = true
    }
    
    func setValuesForRadialGradient(color1: UIColor, color2: UIColor, centerPoint: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat) {
        firstColor = color1
        secondColor = color2
        
        self.centerPoint = centerPoint
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        
        drawRadial = true
    }
    
    override func draw(_ rect: CGRect) {
        
        let colors = [firstColor.cgColor, secondColor.cgColor] as CFArray
        
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        
        if (drawRadial && drawLinear) {
            print("JACOB: Values set for both linear and radial gradients")
            return
        }
        
        if drawRadial {
            if let innerRadius = innerRadius, let outerRadius = outerRadius, let centerPoint = centerPoint {
                //let context = UIGraphicsBeginImageContext(self.frame.size)
                UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: centerPoint, startRadius: innerRadius, endCenter: centerPoint, endRadius: outerRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
            } else {
                print("JACOB: Not creating the radial gradient. One of the required values for drawing is not set.")
            }
        }
        
        if drawLinear {
            if let startPoint = startPoint, let endPoint = endPoint {
                UIGraphicsGetCurrentContext()!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.drawsAfterEndLocation)
            } else {
                print("JACOB: Not creating the linear gradient")
            }
        }
    }
}
