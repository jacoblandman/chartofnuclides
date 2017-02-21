//
//  PopupIsotopeCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/14/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class PopupIsotopeCell: UITableViewCell {

    @IBOutlet weak var symbolLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    func updateCell(isotope: Isotope) {
        symbolLbl.text = "\(isotope.element.symbol)\(isotope.atomicNumber)"
        nameLbl.text = "\(isotope.element.name) \(isotope.atomicNumber)"
    }

}
