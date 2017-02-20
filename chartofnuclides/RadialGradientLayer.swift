//
//  RadialGradientLayer.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class RadialGradientLayer: CALayer {

    var innerRadius: CGFloat!
    var outerRadius: CGFloat!
    var center: CGPoint!
    
    init(center: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat) {
        
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.center = center
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        
        //CGContext.saveGState(ctx)
        
//        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: innerRadius, endCenter: center, endRadius: outerRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        
        
    }
}
