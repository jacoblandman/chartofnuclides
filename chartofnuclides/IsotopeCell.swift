//
//  IsotopeCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class IsotopeCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var shadowView: ShadowView!
    var isotope: Isotope?
    
    func updateCell(isotope: Isotope) {
        
        self.nameLbl.text = "\(isotope.element.symbol)\(isotope.atomicNumber)"
        self.isotope = isotope
    }
    
    func highlight() {
        
        shadowView.backgroundColor = UIColor.black
        shadowView.alpha = 0.5
    }
    
    func unhighlight() {
        shadowView.backgroundColor = UIColor.white
        shadowView.alpha = 1.0
    }
}
