//
//  GradientView.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class GradientView: UIView {

    private var firstColor: UIColor = UIColor.clear
    private var secondColor: UIColor = UIColor.clear
    
    private var relativeStartPoint: CGPoint?
    private var relativeEndPoint: CGPoint?
    
    private var relativeCenterPoint: CGPoint?
    private var innerRadius: CGFloat?
    private var outerRadius: CGFloat?
    
    private var drawLinear: Bool = false
    private var drawRadial: Bool = false
    
    
    func setValuesForLinearGradient(color1: UIColor, color2: UIColor, relativeStartPoint: CGPoint, relativeEndPoint: CGPoint) {
        firstColor = color1
        secondColor = color2
        
        self.relativeStartPoint = relativeStartPoint
        self.relativeEndPoint = relativeEndPoint
        
        drawLinear = true
    }
    
    func setValuesForRadialGradient(color1: UIColor, color2: UIColor, relativeCenterPoint: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat) {
        firstColor = color1
        secondColor = color2
        
        self.relativeCenterPoint = relativeCenterPoint
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
            if let innerRadius = innerRadius, let outerRadius = outerRadius, let relativeCenter = relativeCenterPoint {
                //let context = UIGraphicsBeginImageContext(self.frame.size)
                let centerPoint = CGPoint(x: relativeCenter.x * frame.width, y: relativeCenter.y * frame.height)
                UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: centerPoint, startRadius: innerRadius, endCenter: centerPoint, endRadius: outerRadius, options: [CGGradientDrawingOptions.drawsAfterEndLocation, CGGradientDrawingOptions.drawsBeforeStartLocation])
            } else {
                print("JACOB: Not creating the radial gradient. One of the required values for drawing is not set.")
            }
        }
        
        if drawLinear {
            if let relativeStartPoint = relativeStartPoint, let relativeEndPoint = relativeEndPoint {
                let startPoint = CGPoint(x: relativeStartPoint.x * frame.width, y: relativeStartPoint.y * frame.height)
                let endPoint = CGPoint(x: relativeEndPoint.x * frame.width, y: relativeEndPoint.y * frame.height)
                UIGraphicsGetCurrentContext()!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [CGGradientDrawingOptions.drawsAfterEndLocation, CGGradientDrawingOptions.drawsBeforeStartLocation])
            } else {
                print("JACOB: Not creating the linear gradient")
            }
        }
    }
}
