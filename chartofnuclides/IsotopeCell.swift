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
    @IBOutlet weak var shadowView: UIView!
    var isotope: Isotope?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.addLightShadow()
        shadowView.layer.borderColor = shadowView.colorWithHexString(hex: "B8B8B8").cgColor
        shadowView.layer.borderWidth = 1.0
        shadowView.layer.cornerRadius = 2
    }
    
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
