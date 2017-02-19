//
//  LinearGradient.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/14/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit
//import GBGradientView


@IBDesignable
class LinearGradient: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear
    @IBInspectable var secondColor: UIColor = UIColor.clear
    @IBInspectable var thirdColor: UIColor = UIColor.clear
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        print(self.frame.width)
        (layer as! CAGradientLayer).colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        (layer as! CAGradientLayer).locations = [0 , 0.5, 1]
        (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.0, y: 0.5)
        (layer as! CAGradientLayer).endPoint = CGPoint(x: 1.0, y: 0.5)
        
    }
    
    
}
