//
//  ReportCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 3/20/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell {

    @IBOutlet weak var flagTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(text: String) {
        flagTypeLbl.text = text
    }
}
