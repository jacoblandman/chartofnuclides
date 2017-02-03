//
//  BorderlessSearchBar.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class BorderlessSearchBar: UISearchBar {

    override func awakeFromNib() {
        self.isTranslucent = false
        self.backgroundImage = UIImage()
        self.tintColor = GREEN_COLOR
        self.backgroundColor = GREEN_COLOR
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
