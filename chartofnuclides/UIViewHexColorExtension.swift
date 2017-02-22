//
//  UIViewHexColorExtension.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/15/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

extension UIView {
    
    func colorWithHexString(hex: NSString) -> UIColor {
        var cString = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        // strip 0X if it appears
        if cString.hasPrefix("0X") {
            cString = cString.substring(from: 2)
        }
        
        // String should be 6 or 8 characters
        guard ( cString.characters.count == 6 ) else { return UIColor.gray }
        
        // Separate into r, g, b substrings
        let rString = cString.substring(from: 0, to: 1)
        let gString = cString.substring(from: 2, to: 3)
        let bString = cString.substring(from: 4, to: 5)
        
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b:CUnsignedInt = 0
        
        let _ = Scanner(string: rString).scanHexInt32(&r)
        let _ = Scanner(string: gString).scanHexInt32(&g)
        let _ = Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
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
