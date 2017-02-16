//
//  ConverterCalcCell.swift
//  chartofnuclides
//
//  Created by Jacob Landman on 2/15/17.
//  Copyright © 2017 Jacob Landman. All rights reserved.
//

import UIKit

class ConverterCalcCell: UICollectionViewCell {
    
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTrailingConstraint: NSLayoutConstraint!
    
    
    func update(with indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            switch (indexPath.row) {
            case 0:
                bgView.backgroundColor = colorWithHexString(hex: "FFD276")
            case 1:
                bgView.backgroundColor = colorWithHexString(hex: "FFD276")
            case 2:
                bgView.backgroundColor = colorWithHexString(hex: "98D8F7")
            default:
                bgView.backgroundColor = colorWithHexString(hex: "98D8F7")
            }

            lblLeadingConstraint.constant = self.frame.width / 6
            lblTrailingConstraint.constant = self.frame.width / 6
            mainLbl.textAlignment = .left
            mainLbl.text = "Hello"
            
        } else {
            mainLbl.text = "\(indexPath.row)"
        }
    }
}
