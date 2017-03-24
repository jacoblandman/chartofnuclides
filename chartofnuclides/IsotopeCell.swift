//
//  IsotopeCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/3/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class IsotopeCell: UICollectionViewCell {
    
    @IBOutlet weak var spinLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var massLbl: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var halfLifeLbl: UILabel!
    var isotope: Isotope?
    var originalBGColor = UIColor.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.addLightShadow()
        shadowView.layer.borderColor = shadowView.colorWithHexString(hex: "B8B8B8").cgColor
        shadowView.layer.borderWidth = 1.0
        shadowView.layer.cornerRadius = 2
    }
    
    func updateCell(isotope: Isotope) {
        
        self.isotope = isotope
        self.nameLbl.text = "\(isotope.element.symbol)\(isotope.atomicNumber)"
        self.spinLbl.text = isotope.spin
        
        if isotope.isStable.toBool() {
            if let abundance = isotope.abundance.doubleValue {
                self.halfLifeLbl.text = "\(abundance.roundedTo(places: 6))"
            }
        } else {
            if let halfLife = isotope.halfLife.timeConverted() {
                halfLifeLbl.text = halfLife
            } else {
                halfLifeLbl.text = "\(isotope.halfLife) s"
            }
        }
        
        if let mass = isotope.mass.doubleValue {
            self.massLbl.text = "\(mass.roundedTo(places: 4))"
        }
        
        setBackgroundColor()
        
    }
    
    func setBackgroundColor() {
        if isotope!.isStable.toBool() {
            shadowView.backgroundColor = colorWithHexString(hex: "DCDCDC")
        } else {
            shadowView.backgroundColor = UIColor.white
        }
    }
    
    func highlight() {
        
        originalBGColor = shadowView.backgroundColor!
        shadowView.backgroundColor = UIColor.darkGray
        shadowView.alpha = 0.5
    }
    
    func unhighlight() {
        
        shadowView.backgroundColor = originalBGColor
        shadowView.alpha = 1.0
    }
}
