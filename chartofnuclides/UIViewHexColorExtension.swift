//
//  UIViewHexColorExtension.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/15/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

extension UIView {
        
    func changeBorderColor(to color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
    
    
    func addLightShadow() {
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: SHADOW_GRAY).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.cornerRadius = 1.0
    }
    
    func addDarkShadow() {
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.5).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        layer.cornerRadius = 1.0
    }

}
