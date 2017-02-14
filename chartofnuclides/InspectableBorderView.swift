//
//  InspectableBorderView.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/13/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

@IBDesignable
class InspectableBorderView: InspectableShadowView {

    @IBInspectable var _cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = _cornerRadius
        }
    }
    
    @IBInspectable var _borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = _borderColor.cgColor
        }
    }
    
    @IBInspectable var _borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = _borderWidth
        }
    }
    
}
