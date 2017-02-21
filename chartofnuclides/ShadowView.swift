//
//  FancyView.swift
//  social
//
//  Created by Jacob Landman on 1/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: SHADOW_GRAY).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.cornerRadius = 1.0
        
        layer.borderColor = UIColor(hexString: "B8B8B8").cgColor
        layer.borderWidth = 1
    }

}
