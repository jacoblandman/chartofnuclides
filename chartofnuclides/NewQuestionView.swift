//
//  NewQuestionView.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/13/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class NewQuestionView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.65
        layer.shadowOffset = CGSize(width: 1, height: 2)
        
    }
    
    override func layoutSubviews() {
        addMasks()
    }

    func addMasks() {
        
        let maskLayer = CAShapeLayer()
        
        let rect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let path = CGMutablePath()
        path.addRect(rect)
        
        // first mask
        let circle1 = CGPath(roundedRect: CGRect(x: self.frame.width / 2 - 13 - 54, y: self.frame.height - 27, width: 54, height: 54), cornerWidth: 27, cornerHeight: 27, transform: nil)
        
        // second mask
        let circle2 = CGPath(roundedRect: CGRect(x: self.frame.width / 2 + 13, y: self.frame.height - 27, width: 54, height: 54), cornerWidth: 27, cornerHeight: 27, transform: nil)
        
        path.addPath(circle1)
        path.addPath(circle2)
        
        maskLayer.path = path
        
        // settin the color to clear doesn't work. Needs to be something else to create the mask
        maskLayer.fillColor = UIColor.black.cgColor
        
        maskLayer.fillRule = kCAFillRuleEvenOdd
        self.layer.mask = maskLayer
        
        
    }
}
