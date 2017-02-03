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
    
    func updateCell(isotope: Isotope) {
        self.nameLbl.text = "\(isotope.element.symbol)\(isotope.atomicNumber)"
    }
}
