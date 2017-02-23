//
//  ConversionButton.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/23/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ConversionButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.alpha = self.isHighlighted ? 0.6 : 1.0
            }, completion: nil)
        }
    }
}
