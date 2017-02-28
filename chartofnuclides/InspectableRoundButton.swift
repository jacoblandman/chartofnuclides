//
//  InspectableRoundButton.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/28/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

@IBDesignable
class InspectableRoundButton: UIButton {

    @IBInspectable var _cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = _cornerRadius
        }
    }

}
