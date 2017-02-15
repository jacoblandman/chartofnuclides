//
//  ConversionUnitCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/14/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ConversionUnitCell: UICollectionViewCell {
    
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var unitImg: UIImageView!
    
    func updateCell(unitName: String) {
        
        if unitName == "Work" {
            unitLbl.text = "Work/Energy"
        } else {
            unitLbl.text = unitName
        }
        unitImg.image = UIImage(named: unitName.lowercased().replacingOccurrences(of: " ", with: ""))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.superview!.frame.width
        if (width < 374) {
            unitLbl.font = UIFont(name: "Avenir", size: 14)
        } else if (width < 413) {
            unitLbl.font = UIFont(name: "Avenir", size: 17)
        }
    }
    
}
