//
//  InspectableShadowView.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/13/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

@IBDesignable
class InspectableShadowView: UIView {

    // shadow code
    @IBInspectable var _shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = _shadowColor.cgColor
        }
    }
    
    @IBInspectable var _shadowOffset: CGSize = CGSize.zero {
        didSet {
            layer.shadowOffset = _shadowOffset
        }
    }
    
    @IBInspectable var _shadowOpacity: Float = 1.0 {
        didSet {
            layer.shadowOpacity = _shadowOpacity
        }
    }
    
    @IBInspectable var _shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = _shadowRadius
        }
    }

}
