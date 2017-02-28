//
//  CircleImageView.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/28/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // width is 150, so to make a circle the corner radius needs to be 75
        self.layer.cornerRadius = 75
        
    }

}
