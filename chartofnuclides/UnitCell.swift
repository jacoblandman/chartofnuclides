//
//  UnitCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/22/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class UnitCell: UITableViewCell {

    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var unitAbbreviationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(unit: String) {
        unitLbl.text = unit
    }

}
