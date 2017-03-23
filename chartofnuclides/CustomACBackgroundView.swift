//
//  CustomACBackgroundView.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/22/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class CustomACBackgroundView: UIView {

    @IBOutlet weak var acView: InspectableBorderView!
    
    override func layoutSubviews() {
        addMask()
    }
    
    func addMask() {
        let maskLayer = CAShapeLayer()
        
        let path = CGMutablePath()
        path.addRect(self.frame)
        path.addRoundedRect(in: acView.frame, cornerWidth: 10, cornerHeight: 10)
        
        maskLayer.path = path
        
        maskLayer.fillColor = UIColor.black.cgColor
        
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.cornerRadius = 10
        self.layer.mask = maskLayer
    }

}
